cmake_minimum_required(VERSION 3.15)
project(DreamcastGTAStyle VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Pobranie Simulanta
include(FetchContent)
FetchContent_Declare(
    simulant
    GIT_REPOSITORY https://github.com/simulant/simulant.git
    GIT_TAG        main
)
FetchContent_MakeAvailable(simulant)

# Główny plik wykonywalny MUSI nazywać się 1ST_READ.BIN
add_executable(1ST_READ.BIN src/main.cpp)
target_link_libraries(1ST_READ.BIN PRIVATE simulant)

# --- Generowanie obrazu CD-R ---
add_custom_target(dist
    # 1. Tworzymy strukturę katalogów dla dysku
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/disc
    
    # 2. Kopiujemy plik wykonywalny
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:1ST_READ.BIN> ${CMAKE_BINARY_DIR}/disc/1ST_READ.BIN
    
    # 3. Kopiujemy nasz plik IP.BIN do folderu build (żeby mkisofs go znalazł)
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/ip.bin ${CMAKE_BINARY_DIR}/ip.bin
    
    # 4. Generujemy ISO z odpowiednimi flagami dla Dreamcasta
    # -V "SEGA SEGAKATANA" to wymagany Volume ID dla Dreamcasta
    # -G ip.bin wstrzykuje sektor bootujący
    COMMAND mkisofs -C 0,11702 -V "SEGA SEGAKATANA" -G ${CMAKE_BINARY_DIR}/ip.bin -joliet -rock -o ${CMAKE_BINARY_DIR}/game.iso ${CMAKE_BINARY_DIR}/disc/
    
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    DEPENDS 1ST_READ.BIN
    COMMENT "Generowanie bootowalnego obrazu ISO dla CD-R"
)
