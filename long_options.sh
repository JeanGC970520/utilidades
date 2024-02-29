#!/usr/bin/env bash 

optspec=":io:v-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            echo "${OPTARG}"
            case "${OPTARG}" in
                input)
                    input_file="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    echo "Specified input file with '--${OPTARG}': ${input_file}" >&2;
                    ;;
                input=*)
                    input_file=${OPTARG#*=}
                    echo "Specified input file with '--input=${input_file}'" >&2;
                    ;;
                output)
                    output_file="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    echo "Specified output file with '--${OPTARG}': ${output_file}" >&2;
                    ;;
                output=*)
                    output_file=${OPTARG#*=}
                    echo "Specified output file with '--output=${output_file}'" >&2;
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        i)
            echo "Specified input file with '-i': ${OPTARG}" >&2;
            ;;
        o)
            echo "Specified output file with '-o': ${OPTARG}" >&2;
            ;;
        v)
            echo "Verbose mode activated with '-v'" >&2;
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done