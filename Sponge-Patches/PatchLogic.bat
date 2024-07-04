@echo off
setlocal enabledelayedexpansion

REM Set the prompt for the shell
set PS1=$
set "basedir=%~1"
set "workdir=%basedir%\work"
set "gpgsign=!git config commit.gpgsign || echo false!"
echo Rebuilding Forked projects....

REM Function to enable commit signing if needed
:enableCommitSigningIfNeeded
if "!gpgsign!"=="true" (
    echo Re-enabling GPG Signing
    REM Yes, this has to be global
    git config --global commit.gpgsign true
)

REM Function to apply patches
:applyPatch
set "what=%~1"
set "what_name=!%what%!"
set "target=%~2"
set "branch=%~3"

cd "%basedir%\!what!"
git fetch
git branch -f upstream "!branch!" >NUL

cd "%basedir%"
if not exist "%basedir%\!target!" (
    git clone "!what!" "!target!"
)
cd "%basedir%\!target!"

echo Resetting !target! to !what_name!...
git remote rm upstream > NUL
git remote add upstream "%basedir%\!what!" > NUL
git checkout master 2>NUL || git checkout -b master
git fetch upstream > NUL
git reset --hard upstream/upstream

echo Applying patches to !target!...

git am --abort > NUL
git am --3way --ignore-whitespace "%basedir%\!what_name!-Patches\*.patch"
if errorlevel 1 (
    echo Something did not apply cleanly to !target!.
    echo Please review the details above and finish the apply, then
    echo save the changes with rebuildPatches.bat
    call :enableCommitSigningIfNeeded
    exit /b 1
) else (
    echo Patches applied cleanly to !target!
)

REM Disable GPG signing before AM, slows things down and doesn't play nicely.
REM There is also zero rational or logical reason to do so for these sub-repo AMs.
REM Calm down, it's re-enabled (if needed) immediately after, pass or fail.
if "!gpgsign!"=="true" (
    echo _Temporarily_ disabling GPG signing
    git config --global commit.gpgsign false
)

REM Apply patches for BungeeCord
call :applyPatch SpongeAPI BeodeulSpongeAPI HEAD
call :applyPatch Vanilla Bukkit HEAD
call :applyPatch Forge NeoForge HEAD
call :applyPatch 
REM Enable commit signing if needed
call :enableCommitSigningIfNeeded
exit /b
