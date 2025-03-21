if(CGAL_CreateSingleSourceCGALProgram_included)
  return()
endif(CGAL_CreateSingleSourceCGALProgram_included)
set(CGAL_CreateSingleSourceCGALProgram_included TRUE)

include(${CMAKE_CURRENT_LIST_DIR}/CGAL_add_test.cmake)
include(CMakeParseArguments)

function(CGAL_check_target_name target_name new_target_var_name)
  set(cmake_reserved_names all ALL_BUILD help install
    INSTALL preinstall clean edit_cache
    rebuild_cache ZERO_CHECK package PACKAGE package_source test RUN_TESTS)

  while(TARGET "${target_name}" OR target_name IN_LIST cmake_reserved_names)
    message(AUTHOR_WARNING "The executable name ${target_name} is reserved by CMake or already exists. Renaming it to ${target_name}_")
    set(target_name "${target_name}_")
  endwhile()

  set(${new_target_var_name} ${target_name} PARENT_SCOPE)
endfunction()

function(create_single_source_cgal_program firstfile )
  set(options NO_TESTING)
  set(oneValueArgs)
  set(multiValueArgs CXX_FEATURES)
  cmake_parse_arguments(create_single_source_cgal_program
    "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  set(CXX_FEATURES ${create_single_source_cgal_program_CXX_FEATURES})
  set(NO_TESTING ${create_single_source_cgal_program_NO_TESTING})

  if(NOT IS_ABSOLUTE "${firstfile}")
    set(firstfile "${CMAKE_CURRENT_SOURCE_DIR}/${firstfile}")
  endif()

  get_filename_component(exe_name ${firstfile} NAME_WE)

  if(EXISTS "${firstfile}")

    if(CXX_FEATURES)
      set(MISSING_CXX_FEATURES ${CXX_FEATURES})
      if(CMAKE_CXX_COMPILE_FEATURES)
        list(REMOVE_ITEM MISSING_CXX_FEATURES ${CMAKE_CXX_COMPILE_FEATURES})
      endif()
    endif()
    # Now MISSING_CXX_FEATURES is the set CXX_FEATURES minus CMAKE_CXX_COMPILE_FEATURES
    if(MISSING_CXX_FEATURES)
      message(STATUS "NOTICE: ${exe_name}.cpp requires the C++ features \"${MISSING_CXX_FEATURES}\" and will not be compiled.")
      return()
    endif()

    set( all "${firstfile}" )

    # remaining files
    foreach( i ${create_single_source_cgal_program_UNPARSED_ARGUMENTS} )
      set( all ${all} ${CMAKE_CURRENT_SOURCE_DIR}/${i} )
    endforeach()

    CGAL_check_target_name(${exe_name} exe_name)
    add_executable(${exe_name} ${all})
    if(CXX_FEATURES)
      target_compile_features(${exe_name} PRIVATE ${CXX_FEATURES})
    endif()

    get_directory_property(folder_NO_TESTING CGAL_NO_TESTING)

    if(folder_NO_TESTING OR NOT CGAL_ENABLE_TESTING)
      set(NO_TESTING TRUE)
    endif()

    add_to_cached_list( CGAL_EXECUTABLE_TARGETS ${exe_name} )

    target_link_libraries(${exe_name} PRIVATE CGAL::CGAL CGAL::Data)
    foreach(comp ${CGAL_REQUESTED_COMPONENTS})
      if(TARGET CGAL::CGAL_${comp})
        target_link_libraries(${exe_name} PRIVATE CGAL::CGAL_${comp})
      endif()
    endforeach()
    if(CGAL_3RD_PARTY_LIBRARIES)
      target_link_libraries(${exe_name} PRIVATE ${CGAL_3RD_PARTY_LIBRARIES})
    endif()

    if(NOT NO_TESTING)
      cgal_add_test(${exe_name})
    else()
      cgal_add_test(${exe_name} NO_EXECUTION)
    endif()

  else()
    message(AUTHOR_WARNING "The executable ${exe_name} will not be created because the source file ${firstfile} does not exist.")
  endif()

endfunction()
