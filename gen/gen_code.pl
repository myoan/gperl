use JSON qw/encode_json decode_json/;
use Data::Dumper;

sub read_code_data {
    my $file_name = shift;
    open(ins, "<" . $file_name);
    my $json_data;
    foreach (<ins>) {
        $json_data .= $_;
    }
    my $data = decode_json($json_data);
    my @array = @{$data};
    return @array;
}

sub get_inst_data {
    my $ref = shift;
    my @array = @{$ref};
    my @ret = ();
    foreach (@array) {
        my @inst_names = ();
        my @fast_inst_names = ();
        my $inst_name = $_->{code};
        my $type_flag = $_->{type};
        my $const_flag = $_->{const};
        my $fast_type = $_->{fast_type};
        my @args = $_->{args};
        my $type = $_->{op_type};
        my @fast_prefix;
        if ($fast_type == 1) {
            @fast_prefix = qw{AB AC AD BC BD CD};
        } else {
            @fast_prefix = qw{A B C D};
        }
        push(@inst_names, ${inst_name});
        if ($type_flag) {# gen Int, Double, String, Object, (TypeInference)
            push(@inst_names, "STATIC_${inst_name}");
            push(@inst_names, "d${inst_name}");
            push(@inst_names, "i${inst_name}");
            if ($inst_name !~ /SUB/ && $inst_name !~ /DIV/) {
                push(@inst_names, "s${inst_name}");
            }
            push(@inst_names, "o${inst_name}");
            if ($fast_type) {
                foreach (@fast_prefix) {
                    push(@fast_inst_names, "${_}_${inst_name}");
                    push(@fast_inst_names, "${_}_STATIC_${inst_name}");
                    push(@fast_inst_names, "${_}_d${inst_name}");
                    push(@fast_inst_names, "${_}_i${inst_name}");
                    if ($inst_name !~ /SUB/ && $inst_name !~ /DIV/) {
                        push(@fast_inst_names, "${_}_s${inst_name}");
                    }
                    push(@fast_inst_names, "${_}_o${inst_name}");
                }
            }
            if ($const_flag) {
                push(@inst_names, "d${inst_name}C");
                push(@inst_names, "i${inst_name}C");
                if ($fast_type) {
                    @fast_prefix = ("A", "B", "C", "D");
                    foreach (@fast_prefix) {
                        push(@fast_inst_names, "${_}_${inst_name}C");
                        push(@fast_inst_names, "${_}_d${inst_name}C");
                        push(@fast_inst_names, "${_}_i${inst_name}C");
                        if ($inst_name !~ /SUB/ && $inst_name !~ /DIV/) {
                            push(@fast_inst_names, "${_}_s${inst_name}C");
                        }
                        if ($inst_name !~ /ADD/ &&
                            $inst_name !~ /SUB/ &&
                            $inst_name !~ /MUL/ &&
                            $inst_name !~ /DIV/) {
                            push(@fast_inst_names, "${_}_o${inst_name}C");
                        }
                    }
                }
            }
        } elsif ($const_flag) {
            push(@inst_names, "${inst_name}C");
            if ($fast_type) {
                @fast_prefix = ("A", "B", "C", "D");
                foreach (@fast_prefix) {
                    push(@fast_inst_names, "${_}_${inst_name}C");
                }
            }
        } else {
            if ($fast_type) {
                foreach (@fast_prefix) {
                    push(@fast_inst_names, "${_}_${inst_name}");
                }
            }
        }
        my %hash = (
            orig => $inst_name,
            inst_names => \@inst_names,
            fast_inst_names => \@fast_inst_names,
            args => \@args,
            op_type => $type
            );
        push(@g_inst, @inst_names);
        push(@g_final_inst, @fast_inst_names);
        push(@ret, \%hash);
    }
    return @ret;
}

sub get_type_data {
    my $ref = shift;
    my @array = @{$ref};
    my $map = {};
    foreach $hash (@array) {
        $map->{$hash->{op_type}}++;
    }
    return $map;
}

sub get_map_data {
    my $ref = shift;
    my @array = @{$ref};
    my $map = {};
    foreach $hash (@array) {
        $map->{$hash->{orig}} = $hash->{op_type};
    }
    return $map;
}


sub gen_enum_code {
    my $ret = "typedef enum {\n";
    my $ref = $_[0];
    my @insts = @{$ref};
    my @fast_inst_names = ();
    foreach my $inst (@insts) {
        my @inst_names = @{$inst->{inst_names}};
        my @_fast_inst_names = @{$inst->{fast_inst_names}};
        push(@fast_inst_names, @_fast_inst_names);
        foreach (@inst_names) {
            $ret .= "\t$_,\n";
        }
    }
    foreach (@fast_inst_names) {
        $ret .= "\t$_,\n";
    }
    $ret .= "} GPerlOpCode;\n";
    $ret .= "\n";
	my @types = keys(%{$_[1]});
	$ret .= "typedef enum {\n";
	foreach my $type (@types) {
		$ret .= "\t$type,\n";
	}
    $ret .= "} GPerlOpCodeType;\n";
    $ret .= "\n";
    $ret .= "
typedef struct _GPerlCodeInfo {
	GPerlOpCode code;
	const char *name;
	GPerlOpCodeType type;
} GPerlCodeInfo;\n\n";
    return $ret;
}

sub gen_info_code {
    my $ret = "";
    $ret .= "GPerlCodeInfo decl_codes[] = {\n";
    my $ref = $_[0];
    my @insts = @{$ref};
    my $map = get_map_data(\@insts);
    my @fast_inst_names = ();
    foreach my $inst (@insts) {
        my @inst_names = @{$inst->{inst_names}};
        foreach (@inst_names) {
            $map->{$_} = $map->{$inst->{orig}};
        }
        my @_fast_inst_names = @{$inst->{fast_inst_names}};
        foreach (@_fast_inst_names) {
            $map->{$_} = $map->{$inst->{orig}};
        }
        push(@fast_inst_names, @_fast_inst_names);
        foreach (@inst_names) {
            my $type = $map->{$_};
            $ret .= "\t{$_, \"${_}\", ${type}},\n";
        }
    }
    foreach (@fast_inst_names) {
        my $type = $map->{$_};
        $ret .= "\t{$_, \"${_}\", ${type}},\n";
    }
    $ret .= "};\n";
    return $ret;
}

sub gen_inst_label_code {
    my $ret = "";
    my $jmp_label = "\tstatic void *jmp_table[] = {\n";
    my $ref = shift;
    my @insts = @{$ref};
    my @inst_names = ();
    my @fast_inst_names = ();
    foreach my $inst (@insts) {
        my @_inst_names = @{$inst->{inst_names}};
        my @_fast_inst_names = @{$inst->{fast_inst_names}};
        push(@inst_names, @_inst_names);
        push(@fast_inst_names, @_fast_inst_names);
    }
    for (my $i = 0; $i <= $#inst_names; $i += 3) {
        my $inst = $inst_names[$i];
        my $inst2 = $inst_names[$i+1];
        my $inst3 = $inst_names[$i+2];
        $jmp_label .= "\t    &&L(${inst})," if (defined($inst));
        $jmp_label .= " &&L(${inst2})," if (defined($inst2));
        $jmp_label .= " &&L(${inst3}),\n" if (defined($inst3));
    }
    for (my $i = 0; $i <= $#fast_inst_names; $i += 3) {
        my $inst = $fast_inst_names[$i];
        my $inst2 = $fast_inst_names[$i+1];
        my $inst3 = $fast_inst_names[$i+2];
        $jmp_label .= "\t    &&L(${inst})," if (defined($inst));
        $jmp_label .= " &&L(${inst2})," if (defined($inst2));
        $jmp_label .= " &&L(${inst3}),\n" if (defined($inst3));
    }
    $jmp_label .= "\n\t};\n";
    my $block_label .= "\tstatic InstBlock block_table[] = {\n";
    for (my $i = 0; $i <= $#inst_names; $i += 3) {
        my $inst = $inst_names[$i];
        my $inst2 = $inst_names[$i+1];
        my $inst3 = $inst_names[$i+2];
        $block_label .= "\t    B(${inst})," if (defined($inst));
        $block_label .= " B(${inst2})," if (defined($inst2));
        $block_label .= " B(${inst3}),\n" if (defined($inst3));
    }
    for (my $i = 0; $i <= $#fast_inst_names; $i += 3) {
        my $inst = $fast_inst_names[$i];
        my $inst2 = $fast_inst_names[$i+1];
        my $inst3 = $fast_inst_names[$i+2];
        $block_label .= "\t    B(${inst})," if (defined($inst));
        $block_label .= " B(${inst2})," if (defined($inst2));
        $block_label .= " B(${inst3}),\n" if (defined($inst3));
    }
    $block_label .= "\n\t};\n";
    $ret = $jmp_label . $block_label;
    return $ret;
}

sub gen_inst_body {
    my $ret = "";
    my $ref = shift;
    my @insts = @{$ref};
    foreach my $inst (@insts) {
        my @inst_names = @{$inst->{inst_names}};
        my @args = @{$inst->{args}};
        my $cmp_flag = 0;
        my $ret_flag = 0;

        foreach (@inst_names) {
            my $op = "";
            if ($_ =~ /ADD/) {
                $op .= "+=";
            } elsif ($_ =~ /SUB/) {
                $op .= "-=";
            } elsif ($_ =~ /MUL/) {
                $op .= "*=";
            } elsif ($_ =~ /DIV/) {
                $op .= "/=";
            } elsif ($_ =~ /MOV/) {
                $op .= "=";
            } elsif ($_ =~ /J/ && $_ !~ /JMP/) {
                $cmp_flag = 1;
            } elsif ($_ =~ /RET/) {
                $ret_flag = 1;
            }
            my $decl_args = "";
            foreach (@args) {
                my @a = @{$_};
                my $isFirst = 1;
                foreach (@a) {
                    my %hash = %{$_};
                    my @keys = keys(%hash);
                    if ($isFirst) {
                        $decl_args .= $keys[0];
                        $isFirst = 0;
                    } else {
                        $decl_args .= ", " . $keys[0];
                    }
                }
            }
            if ($cmp_flag) {
                next;
            }
            my $tmp = "#define GPERL_${_}(" . $decl_args . ") ";
            if ($_ =~ /^i/) {
                if ($ret_flag) {
                    $tmp .= "return I(data)[src]\n";
                } else {
                    $tmp .= "I(data)[dst] " . $op . " I(data)[src]\n";
                }
            } elsif ($_ =~ /^d/) {
                if ($ret_flag) {
                    $tmp .= "return D(data)[src]\n";
                } else {
                    $tmp .= "D(data)[dst] " . $op . " D(data)[src]\n";
                }
            } elsif ($_ =~ /^s/) {
                if ($ret_flag) {
                    $tmp .= "return S(data)[src]\n";
                } else {
                    $tmp .= "S(data)[dst] " . $op . " S(data)[src]\n";
                }
            } elsif ($_ =~ /^o/) {
                $tmp .= "\n";
            } else {
                $tmp .= "\n";
            }
            $ret .= $tmp;
        }
    }
    return $ret;
}

my $run_init =
"#include <gperl.hpp>
#include \"gen_decl_code.cpp\"
#include <vmlibs.hpp>

using namespace std;
bool isRunFinished = false;
static void *jitTimingCheck(void *args)
{
	DBG_PL(\"jitTimingCheck\");
	JITParams *params = (JITParams *)args;
	void **jmp_tbl = params->jmp_table;
	size_t params_num = params->params_num;
	JITParam **prms = params->params;
	while (!isRunFinished) {
		for (size_t i = 0; i < params_num; i++) {
			JITParam *param = prms[i];
			if (!param->func && param->mtd->jit_count_down == 0 && param->return_type != Return) {
				//DBG_PL(\"Start JIT Compile\");
				GPerlJITCompiler jit_compiler;
				param->func = jit_compiler.compile(param);
				size_t calls_num = param->calls_num;
				GPerlVirtualMachineCode *mtd = param->mtd;
				for (size_t j = 0; j < calls_num; j++) {
					int offset = param->offsets[j];
					switch ((mtd + offset)->op) {
					case CALL: case FASTCALL0: case FASTCALL1: case FASTCALL2: case FASTCALL3:
						(mtd + offset)->opnext = jmp_tbl[JIT_CALL];
						break;
					case SELFCALL:
						(mtd + offset)->opnext = jmp_tbl[JIT_SELFCALL];
						break;
					case SELF_FASTCALL0:
						(mtd + offset)->opnext = jmp_tbl[JIT_SELF_FASTCALL0];
						break;
					case SELF_FASTCALL1:
						(mtd + offset)->opnext = jmp_tbl[JIT_SELF_FASTCALL1];
						break;
					case SELF_FASTCALL2:
						(mtd + offset)->opnext = jmp_tbl[JIT_SELF_FASTCALL2];
						break;
					case SELF_FASTCALL3:
						(mtd + offset)->opnext = jmp_tbl[JIT_SELF_FASTCALL3];
						break;
					default:
						break;
					}
				}
			}
		}
	}
    return NULL;
}

GPerlValue GPerlVirtualMachine::run(GPerlVirtualMachineCode *codes, JITParams *params)
{
	GPerlVirtualMachineCode *pc = codes, *code_ = NULL, *top = NULL;
	GPerlValue *stack = createMachineStack();
	GPerlEnv *callstack = createCallStack();
	callstack->pc = pc;
	callstack->cur_pc = pc;
	(callstack+1)->cur_pc = pc;
	GPerlValue *argstack = callstack->argstack;
	GPerlValue *reg = callstack->reg;
	callstack->ebp = stack;
	GPerlEnv *callstack_bottom = callstack;
	char shared_buf[128] = {0};//TODO must be variable buffer
	string outbuf = \"\";
	root.stack_bottom = stack;
	root.callstack_bottom = callstack_bottom;
	root.global_vmemory = global_vmemory;
#include \"gen_label.cpp\"
#ifdef ENABLE_JIT_COMPILE
	GPerlJITCompiler jit_compiler;
	if (params && params->params_num > 0) {
		this->params = params;
		pthread_t th;
		params->jmp_table = jmp_table;
		pthread_create(&th, NULL, jitTimingCheck, (void *)params);
	}
#endif
    DISPATCH_START();

";


my $single_static_type_check_code =
"		int type = TYPE_CHECK(reg[pc->dst]);
		pc->opnext = jmp_table[pc->op + 1 + type];
";

my $single_type_check_code =
"		int type = TYPE_CHECK(reg[pc->dst]);
		goto *jmp_table[pc->op + 2 + type];
";

my $double_static_type_check_code =
"		int dst_type = TYPE_CHECK(reg[pc->dst]);
		int src_type = TYPE_CHECK(reg[pc->src]);
		pc->opnext = jmp_table[pc->op + 1 + ((dst_type + src_type) >> 1)];
";

my $double_type_check_code =
"		int dst_type = TYPE_CHECK(reg[pc->dst]);
		int src_type = TYPE_CHECK(reg[pc->src]);
		goto *jmp_table[pc->op + 2 + ((dst_type + src_type) >> 1)];
";

sub gen_vm_run_code {
    my $ret = $run_init;
    my $ref = shift;
    my @insts = @{$ref};
    my @inst_names = ();
    foreach my $inst (@insts) {
        my @inst_names = @{$inst->{inst_names}};
        my @args = @{$inst->{args}};
        foreach (@inst_names) {
            my $orig = $_;
            $ret .= "\tCASE(${_}, {\n";
            my $decl_args = "";
            foreach (@args) {
                my @a = @{$_};
                my $isFirst = 1;
                foreach (@a) {
                    my %hash = %{$_};
                    my @values = values(%hash);
                    if ($isFirst) {
                        $decl_args .= $values[0];
                        $isFirst = 0;
                    } elsif ($values[0] =~ /callname/) {
                        $decl_args .= ", " . $orig;
                    } else {
                        $decl_args .= ", " . $values[0];
                    }
                }
            }
            if ($_ =~ /J/ && $_ !~ /JMP/ && $_ !~ /JIT/) {
                my $prefix = substr($_, 0, 1);
                $prefix = "" if ($prefix =~ /J/);
                if ($_ =~ /C$/) {
                    $decl_args =~ s/pc->src/pc->v/;
                    $ret .= "\t\tGPERL_${prefix}CMP_JMPC(" . $decl_args . ");\n";
                } elsif ($prefix eq "") {
                    $ret .= $double_type_check_code;
                } elsif ($prefix eq "S") {
                    $ret .= $double_static_type_check_code;
                } else {
                    $ret .= "\t\tGPERL_${prefix}CMP_JMP(" . $decl_args . ");\n";
                }
            } elsif ($_ =~ /JMP/) {
                $ret .= "\t\tGPERL_${_}(" . $decl_args . ");\n";
            } elsif ($_ =~ /IS/) {
                my $prefix = substr($_, 0, 1);
                $prefix = "" if ($prefix =~ /I/);
                if ($_ =~ /C$/) {
                    $decl_args =~ s/pc->src/pc->v/;
                    if ($_ =~ /NOT/) {
                        $ret .= "\t\tGPERL_${prefix}ISNOT(" . $decl_args . ");\n";
                    } else {
                        $ret .= "\t\tGPERL_${prefix}IS(" . $decl_args . ");\n";
                    }
                } elsif ($prefix eq "S") {
                    $ret .= $single_static_type_check_code;
                } elsif ($prefix eq "") {
                    $ret .= $single_type_check_code;
                } else {
                    if ($_ =~ /NOT/) {
                        $ret .= "\t\tGPERL_${prefix}ISNOT(" . $decl_args . ");\n";
                    } else {
                        $ret .= "\t\tGPERL_${prefix}IS(" . $decl_args . ");\n";
                    }
                }
            } elsif ($_ =~ /THCODE/) {
            } elsif ($_ =~ /STATIC/ && $_ !~ /CALL/) {
                if ($_ =~ "ADD" || $_ =~ "SUB" ||
                    $_ =~ "MUL" || $_ =~ "DIV" ||
                    $_ =~ "LSHIFT" || $_ =~ "RSHIFT") {
                    $ret .= $double_static_type_check_code;
                } else {
                    my $check_code .= $single_static_type_check_code;
                    $check_code =~ s/reg\[pc\-\>dst\]/stack[pc->dst]/ if ($_ eq "STATIC_INC" || $_ eq "STATIC_DEC");
                    $check_code =~ s/reg\[pc\-\>dst\]/global_vmemory[pc->dst]/ if ($_ eq "STATIC_gINC" || $_ eq "STATIC_gDEC");
                    $ret .= $check_code;
                }
            } elsif ($_ eq "ADD" || $_ eq "SUB" ||
                     $_ eq "MUL" || $_ eq "DIV" ||
                     $_ eq "LSHIFT" || $_ eq "RSHIFT") {
                $ret .= $double_type_check_code;
            } elsif ($_ =~ /ADDC/ || $_ =~ /SUBC/ ||
                     $_ =~ /MULC/ || $_ =~ /DIVC/ ||
                     $_ =~ /LSHIFTC/ || $_ =~ /RSHIFTC/) {
                $decl_args =~ s/pc->src/pc->v/;
                $ret .= "\t\tGPERL_${_}(" . $decl_args . ");\n";
                $ret .= "\t\tpc++;\n";
            } elsif ($_ eq "WRITE" || $_ eq "INC" || $_ eq "gINC" || $_ eq "DEC" || $_ eq "gDEC") {
                my $check_code .= $single_type_check_code;
                $check_code =~ s/reg\[pc\-\>dst\]/stack[pc->dst]/ if ($_ eq "INC" || $_ eq "DEC");
                $check_code =~ s/reg\[pc\-\>dst\]/global_vmemory[pc->dst]/ if ($_ eq "gINC" || $_ eq "gDEC");
                $ret .= $check_code;
            } elsif ($_ eq "REF") {
                $ret .= "\t\tINT_init(reg[0], GPERL_${_}(" . $decl_args . "));\n";
                $ret .= "\t\tpc++;\n";
            } elsif ($_ eq "KEYS" || $_ eq "VALUES") {
                $ret .= "\t\tGPerlArray *a = GPERL_${_}((callstack+1)->argstack[0]);\n";
                $ret .= "\t\tOBJECT_init(reg[pc->dst], a);\n";
                $ret .= "\t\tpc++;\n";
            } elsif ($_ =~ /EACH_STEP/ || $_ =~ /EACH_LET/) {
                $ret .= "\t\tGPERL_${_}(" . $decl_args . ");\n";
            } else {
                $ret .= "\t\tGPERL_${_}(" . $decl_args . ");\n";
                $ret .= "\t\tpc++;\n";
            }
            if ($_ =~ /THCODE/) {
                $ret .= q{		createDirectThreadingCode(codes, jmp_table);
		size_t pkgs_n = pkgs->size();
		for (size_t i = 0; i < pkgs_n; i++) {
			GPerlClass *gclass = (GPerlClass *)pkgs->at(i);
			GPerlString **mtd_names = gclass->ext->mtd_names;
			for (size_t j = 0; mtd_names[j] != NULL; j++) {
				GPerlFunc *mtd = gclass->mtds[mtd_names[j]->hash];
				createDirectThreadingCode(mtd->code, jmp_table);
			}
		}
		(void)block_table;
		//createSelectiveInliningCode(codes, jmp_table, block_table);
		return reg[0];
        };
            } else {
                $ret .= "\t\tBREAK();\n";
            }
            $ret .= "\t});\n";
        }
    }
    $ret .= "#include \"gen_fast_vmcode.cpp\"\n\n";
    $ret .= "\tDISPATCH_END();\n";
    $ret .= "\treturn reg[0];\n";
    $ret .= "}\n";
    return $ret;
}

sub gen_fast_vm_code {
    my $ret = "";
    my $ref = shift;
    my @insts = @{$ref};
    my @inst_names = ();
    foreach my $inst (@insts) {
        my @inst_names = @{$inst->{fast_inst_names}};
        my @args = @{$inst->{args}};
        foreach (@inst_names) {
            my $orig = $_;
            $ret .= "\tCASE(${_}, {\n";
            $_ =~ /_(.*)/;
            my $name = $1;
            my @_code = split("_", $_);
            my $fast_prefix = substr($_code[0], 0, 1);
            my $fast_prefix2 = substr($_code[0], 1, 1);
            my $decl_args = "";
            foreach (@args) {
                my @a = @{$_};
                my $isFirst = 1;
                foreach (@a) {
                    my %hash = %{$_};
                    my @values = values(%hash);
                    if ($isFirst) {
                        if ($values[0] =~ /dst/) {
                            if ($fast_prefix =~ "A") {
                                $decl_args .= "0";
                            } elsif ($fast_prefix =~ "B") {
                                $decl_args .= "1";
                            } elsif ($fast_prefix =~ "C") {
                                $decl_args .= "2";
                            } elsif ($fast_prefix =~ "D") {
                                $decl_args .= "3";
                            }
                        } elsif ($values[0] =~ /src/) {
                            if ($fast_prefix2 =~ "A") {
                                $decl_args .= "0";
                            } elsif ($fast_prefix2 =~ "B") {
                                $decl_args .= "1";
                            } elsif ($fast_prefix2 =~ "C") {
                                $decl_args .= "2";
                            } elsif ($fast_prefix2 =~ "D") {
                                $decl_args .= "3";
                            } elsif (($orig =~ /RET/ || $orig =~ /SHIFT/) &&
                                     $fast_prefix =~ "A") {
                                $decl_args .= "0";
                            } elsif (($orig =~ /RET/ || $orig =~ /SHIFT/) &&
                                     $fast_prefix =~ "B") {
                                $decl_args .= "1";
                            } elsif (($orig =~ /RET/ || $orig =~ /SHIFT/) &&
                                     $fast_prefix =~ "C") {
                                $decl_args .= "2";
                            } elsif (($orig =~ /RET/ || $orig =~ /SHIFT/) &&
                                     $fast_prefix =~ "D") {
                                $decl_args .= "3";
                            }
                        } else {
                            $decl_args .= $values[0];
                        }
                        $isFirst = 0;
                    } else {
                        if ($values[0] =~ /dst/) {
                            if ($fast_prefix =~ "A") {
                                $decl_args .= ", 0";
                            } elsif ($fast_prefix =~ "B") {
                                $decl_args .= ", 1";
                            } elsif ($fast_prefix =~ "C") {
                                $decl_args .= ", 2";
                            } elsif ($fast_prefix =~ "D") {
                                $decl_args .= ", 3";
                            }
                        } elsif ($values[0] =~ /src/) {
                            if ($fast_prefix2 =~ "A") {
                                $decl_args .= ", 0";
                            } elsif ($fast_prefix2 =~ "B") {
                                $decl_args .= ", 1";
                            } elsif ($fast_prefix2 =~ "C") {
                                $decl_args .= ", 2";
                            } elsif ($fast_prefix2 =~ "D") {
                                $decl_args .= ", 3";
                            } else {
                                $decl_args .= ", " . $values[0];
                            }
                        } elsif ($values[0] =~ /callname/) {
                            $decl_args .= ", " . $orig;
                        } else {
                            $decl_args .= ", " . $values[0];
                        }
                    }
                }
            }
            if ($_ =~ /J/ && $_ !~ /JMP/) {
                my $prefix = substr($_code[1], 0, 1);
                $prefix = "" if ($prefix =~ /J/);
                if ($_ =~ /C$/) {
                    $decl_args =~ s/pc->src/pc->v/;
                    $ret .= "\t\tGPERL_${prefix}CMP_JMPC(" . $decl_args . ");\n";
                } elsif ($prefix eq "S") {
                    $ret .= $single_static_type_check_code;
                } elsif ($prefix eq "") {
                    $ret .= $single_type_check_code;
                } else {
                    $ret .= "\t\tGPERL_${prefix}CMP_JMP(" . $decl_args . ");\n";
                }
            } elsif ($_code[1] =~ /STATIC/) {
                $ret .= $single_static_type_check_code;
            } elsif ($_code[1] eq "ADD" || $_code[1] eq "SUB" ||
                     $_code[1] eq "MUL" || $_code[1] eq "DIV" ||
                     $_code[1] eq "LSHIFT" || $_code[1] eq "RSHIFT") {
                $ret .= $single_type_check_code;
            } elsif ($_code[1] =~ /ADDC/ || $_code[1] =~ /SUBC/ ||
                     $_code[1] =~ /MULC/ || $_code[1] =~ /DIVC/ ||
                     $_code[1] =~ /LSHIFTC/ || $_code[1] =~ /RSHIFTC/) {
                $decl_args =~ s/pc->src/pc->v/;
                $ret .= "\t\tGPERL_${name}(" . $decl_args . ");\n";
                $ret .= "\t\tpc++;\n";
            } else {
                $ret .= "\t\tGPERL_${name}(" . $decl_args . ");\n";
                $ret .= "\t\tpc++;\n";
            }
            $ret .= "\t\tBREAK();\n";
            $ret .= "\t});\n";
        }
    }
    return $ret;
}

my @array = read_code_data("gen/code.json");

my @insts = get_inst_data(\@array);
my $type_map = get_type_data(\@array);
open(ous, ">include/gen_vmcode.hpp");
my $enum_code = gen_enum_code(\@insts, $type_map);
print ous $enum_code;

open(ous, ">src/gen_decl_code.cpp");
my $info_code = gen_info_code(\@insts);
print ous $info_code;

open(ous, ">src/gen_label.cpp");
my $label_code = gen_inst_label_code(\@insts);
print ous $label_code;

open(ous, ">src/gen_vm.cpp");
#my $body = gen_inst_body(\@insts);
my $vm_code = gen_vm_run_code(\@insts);
#print ous $body;
print ous $vm_code;
my $fast_vm_code = gen_fast_vm_code(\@insts);
open(ous, ">src/gen_fast_vmcode.cpp");
print ous $fast_vm_code;
