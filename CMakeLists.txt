cmake_minimum_required(VERSION 3.2)

set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchain.cmake" CACHE PATH "")

project(toolchain-info-mini)

set(ENV{HOMEBREW_CCCFG} "")

set(predefined "${CMAKE_CURRENT_LIST_DIR}/ShowPredefined.cpp")

execute_process(COMMAND printenv)

try_compile(
    try_compile_result
    "${CMAKE_BINARY_DIR}/_test"
    "${predefined}"
    CMAKE_FLAGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
    OUTPUT_VARIABLE outresult
)

if(NOT try_compile_result)
  message(
      FATAL_ERROR
      "Compilation of ${predefined} failed. Result: ${try_compile_result}\n"
      "Output:\n--- OUTPUT BEGIN ---\n${outresult}\n--- OUTPUT END ---"
  )
endif()

function(split_string string_in result)
  set("${result}" "")

  while(TRUE)
    string(COMPARE EQUAL "${string_in}" "" is_empty)
    if(is_empty)
      break()
    endif()

    string(FIND "${string_in}" "\n" eol_pos)
    if(eol_pos EQUAL -1)
      list(APPEND "${result}" "${string_in}")
      break()
    endif()

    string(SUBSTRING "${string_in}" 0 ${eol_pos} substring)
    list(APPEND "${result}" "${substring}")
    math(EXPR eol_pos "${eol_pos} + 1") # Skip EOL character
    string(SUBSTRING "${string_in}" ${eol_pos} -1 string_in)
  endwhile()

  set(${result} "${${result}}" PARENT_SCOPE)
endfunction()

split_string("${outresult}" list_of_strings)

set(macroses "")
foreach(x ${list_of_strings})
  string(
      REGEX
      MATCH
      "__HUNTER_MACRO_CHECK_BEGIN__.*__HUNTER_MACRO_CHECK_END__"
      result_x
      "${x}"
  )
  if(result_x)
    string(
        REGEX
        REPLACE
        ".*__HUNTER_MACRO_CHECK_BEGIN__\(.*\)__HUNTER_MACRO_CHECK_END__.*"
        "\\1"
        result_x
        "${x}"
    )
    set(macroses "${macroses}${result_x}\n")
  endif()
endforeach()

string(COMPARE EQUAL "${macroses}" "" is_empty)
if(is_empty)
  message(
      FATAL_ERROR
      "No toolchain info generated from output:\n"
      "--- BEGING ---"
      "${outresult}"
      "--- END ---"
      "(Try compile result: ${try_compile_result})"
  )
endif()

message("Predefined macroses:\n${macroses}")
