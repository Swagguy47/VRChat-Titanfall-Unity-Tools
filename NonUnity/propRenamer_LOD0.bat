echo "Renamer - GODHC"
@echo off
for %%f in (*.cast) do (
ren "%%~nf%%~xf" "%%~nf_LOD0%%~xf"
md "%%~nf" && move "%%~nf_LOD0%%~xf" "%%~nf"

)
@echo on
echo "Files renamed:"
for %%f in (*.cast) do (
echo "%%~nf%%~xf"
)
echo "Job done!"