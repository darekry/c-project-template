# 'make'        build executable file 'main'
# 'make clean'  removes all .o and executable files

# define the C compiler to use
CC = gcc

# define the Cpp compiler to use
CXX = g++

# define any compile-time flags for C
CFLAGS	:= -Wall
CFLAGS	+= -Wextra
CFLAGS	+= -g
CFLAGS	+= $(shell sdl2-config --cflags)

# define any compile-time flags for C++
CXXFLAGS	:= -std=c++17
CXXFLAGS	+= -Wall
CXXFLAGS	+= -Wextra
CXXFLAGS	+= -g
CXXFLAGS	+= $(shell sdl2-config --cflags)

# define library paths in addition to /usr/lib
LFLAGS = $(shell sdl2-config --libs)
LFLAGS += -lSDL2_image

# define output directory
OUTPUT	:= output

# define source directory
SRC		:= src

# define include directory
INCLUDE	:= include

# define lib directory
LIB		:= lib

MAIN	:= main.exe
#to ex
EXCLUDE_DIRS ?= exclude_dir1 exclude_dir2

SOURCEDIRS	:= $(filter-out $(addprefix $(SRC)/,$(EXCLUDE_DIRS)), $(shell find $(SRC) -type d))
INCLUDEDIRS	:= $(shell find $(INCLUDE) -type d)
LIBDIRS		:= $(shell find $(LIB) -type d)

# define any directories containing header files other than /usr/include
INCLUDES	:= $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# define the C libs
LIBS		:= $(patsubst %,-L%, $(LIBDIRS:%/=%))

# define the C and Cpp source files
CSOURCES	:= $(wildcard $(patsubst %,%/*.c, $(SOURCEDIRS)))
CPPSOURCES	:= $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))

# define the C and Cpp object files
COBJECTS	:= $(patsubst $(SRC)/%.c,$(OUTPUT)/%.o,$(CSOURCES))
CPPOBJECTS	:= $(patsubst $(SRC)/%.cpp,$(OUTPUT)/%.o,$(CPPSOURCES))

# define the dependency output files
CDEPS		:= $(patsubst $(SRC)/%.c,$(OUTPUT)/%.d,$(CSOURCES))
CPPDEPS	:= $(patsubst $(SRC)/%.cpp,$(OUTPUT)/%.d,$(CPPSOURCES))

OUTPUTMAIN	:= $(OUTPUT)/$(MAIN)

all: $(OUTPUT) $(MAIN)
	@echo Executing 'all' complete!

$(OUTPUT):
	mkdir -p $(OUTPUT)

$(MAIN): $(COBJECTS) $(CPPOBJECTS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN) $(COBJECTS) $(CPPOBJECTS) $(LFLAGS) $(LIBS)

-include $(CDEPS)
-include $(CPPDEPS)

# this is a suffix replacement rule for building .o's from .c's
$(OUTPUT)/%.o: $(SRC)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -c -MMD $<  -o $@

# this is a suffix replacement rule for building .o's from .cpp's
$(OUTPUT)/%.o: $(SRC)/%.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c -MMD $<  -o $@

.PHONY: clean
clean:
	rm -rf $(OUTPUT)
	@echo Cleanup complete!

run: all
	./$(OUTPUTMAIN)
	@echo Executing 'run: all' complete!
