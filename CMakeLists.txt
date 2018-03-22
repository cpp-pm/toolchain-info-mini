cmake_minimum_required(VERSION 3.2)
project(toolchain-info-mini)

add_custom_target(
    cccfg
    ALL
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/script.cmake
)
