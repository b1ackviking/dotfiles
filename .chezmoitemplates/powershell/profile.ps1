$env:EDITOR="nvim";
$env:CMAKE_GENERATOR="Ninja";
$env:CMAKE_BUILD_TYPE="RelWithDebInfo";
$env:CMAKE_CONFIGURATION_TYPES="Debug;Release;MinSizeRel;RelWithDebInfo";
$env:CMAKE_CONFIG_TYPE="RelWithDebInfo";
$env:CMAKE_EXPORT_COMPILE_COMMANDS="TRUE";
$env:CMAKE_COLOR_DIAGNOSTICS="ON";
$env:CTEST_OUTPUT_ON_FAILURE="TRUE";
$env:CTEST_PROGRESS_OUTPUT="TRUE";
$env:CTEST_PARALLEL_LEVEL="";
$env:CONAN_CMAKE_GENERATOR="Ninja";
$env:CONAN_SYSREQUIRES_MODE="verify";
$env:CONAN_SYSREQUIRES_SUDO="True";

Set-Alias -Name vim -Value nvim;
del alias:cat -Force
Set-Alias -Name cat -Value bat;
Set-Alias -Name lg -Value lazygit;
Set-Alias -Name la -Value ls;
