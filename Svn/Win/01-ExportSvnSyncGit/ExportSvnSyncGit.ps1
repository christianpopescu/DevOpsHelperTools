# ------------------------------------------
# Description   : Export SVN files modified between two revisions
# Creation Date : 03/07/2017
# --------------------------
# Modification : 
#                - 27/07/2017 :
#                               - Check and Change Git Version
#                - 17/11/2017 - Get configurationn file
# Precondition: Execute into Git folder (2017/09/15)
# Parameters  : $configFileName = the configuration file to be used
#               $batchMode = if true: no message shown, no questions asked  
# Scenario    :
# 1 - Check that Subversion is up to date                    --> If not message + exits
# 2 - Check that nothing to commit on the current branch     --> If not message + exits
# 3 - Check that Git workspace is on good branch             --> If not message + exits  
# 4 - Get the last synchronisation information : commit id, name
# 5 - Verify that that commit number and name exists
# 6 - Create export folder based on svn last version
# 7 - Export svn vers the export folder     
# ------------------------------------------
param([string]$configFileName = '.\ConfigSvn.xml',
       [Boolean]$batchMode = $false)
 
# -- Read context from XML Config File
# Pattern - to finish for all parameters
# $configFile = [xml] (Get-Content .\ConfigSvn.xml)
$configFile = [xml] (Get-Content $configFileName)
 
$pathToSvnConfig = '/Config/Context/Svn'
$cntxSvn = $configFile.SelectSingleNode($pathToSvnConfig).Uri
 
$pathToTargetRoot = '/Config/Context/SyncTarget'
$cntxTarget = $configFile.SelectSingleNode($pathToTargetRoot).Root + $configFile.SelectSingleNode($pathToTargetRoot).Folder
 
$pathToRevisionInterval = '/Config/Context/RevisionInterval'
$cntxRevBegin = $configFile.SelectSingleNode($pathToRevisionInterval).Before
$cntxRevEnd = $configFile.SelectSingleNode($pathToRevisionInterval).End
 
$pathToLogFile = '/Config/Context/Log'
$cntxLogFile = $configFile.SelectSingleNode($pathToLogFile)
 
$pathToGitParam = '/Config/Context/Git'
$cntxGitWorkspace = $configFile.SelectSingleNode($pathToGitParam).Workspace
$cntxGitTargetBranch = $configFile.SelectSingleNode($pathToGitParam).TargetBranch
 
 
# Add types
Add-Type -AssemblyName PresentationFramework          ## to show messages
 
# -- Context
# $cntxSvn = "file://trunk/cpp"
# $cntxTarget ="H:\ccp_vhdd\Workspace\Sync\DiskE\2017_09_08_svn_18268"
# $cntxRevBegin = "18145"
# $cntxRevEnd = "HEAD"
# $cntxLogFile = "e:\temp\log_export_svn.log"
# $cntxGitWorkspace = "E:\ccp_vhdd\Workspace\LocalWorkspace\Cpp"
# $cntxGitTargetBranch = "master"
 
 
 
# Chek that nothing to commit to current branch
# ---------------------------------------------
cd $cntxGitWorkspace
[int]$cnt = (git status --porcelain | Measure-Object)."Count"
 
if ($cnt -ne 0)
  {
  if ($batchMode -eq $false) {
    [System.Windows.MessageBox]::Show("There are uncomitted modification on git folder")
    }
  return
  }
 
# Check Git current branch
# ---------------------------------------------
cd $cntxGitWorkspace
$currentBranch = git branch | where {$_ -match '^\*'} | ForEach-Object { $_ -replace "\*\s*", ""} | Select-Object -First 1
 
if ($currentBranch -ne $cntxGitTargetBranch)
{
  if ($batchMode -eq $false) {
    [System.Windows.MessageBox]::Show("Git working folder is not on the ""appropriete"" branch! ")
    }
    return
}
 
# find file modified/added to export
# ---------------------------------------------
#svn diff --xml -r  ${cntxRevBegin}:$cntxRevEnd --summarize $cntxSvn | Out-File E:\Temp\diffsvn.txt
 
[xml]$modifications =  svn diff --xml -r  ${cntxRevBegin}:$cntxRevEnd --summarize $cntxSvn
 
$path ="/diff/paths/*"
 
$nodelist = $modifications.SelectNodes($path)
 
 
# export files added/modified
# ---------------------------------------------
foreach ($element in $nodelist)
{
    #$element.item
    #$element.kind
    if (($element.kind -like "file*") -and ($element.item -notlike "deleted*"))
    {
        $sourceElement = $element.InnerText
        # destination folder = eliminate file name + eliminate svn url + replace / by \
        $destElement = $cntxTarget + $sourceElement.Substring(0,$sourceElement.LastIndexOf("/")+1).Replace($cntxSvn,"").Replace("/","\")
       New-Item -ItemType Directory -Force -Path $destElement
       svn export $sourceElement $destElement | Out-File -Append $cntxLogFile 
    }
}
 
