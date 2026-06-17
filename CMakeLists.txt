cmake_minimum_required(VERSION 3.15)
project(DreamcastGame)

# Prosty plik wykonywalny
add_executable(1ST_READ.BIN src/main.cpp)

# Generowanie ISO
add_custom_target(dist
    COMMAND mkdir -p disc
    COMMAND cp 1ST_READ.BIN disc/
    COMMAND cp ../ip.bin .
    COMMAND mkisofs -C 0,11702 -V "SEGA SEGAKATANA" -G ip.bin -joliet -rock -o game.iso disc/
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS 1ST_READ.BIN
)
