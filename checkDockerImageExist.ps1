# try find image(s) by name
# https://www.dummies.com/computers/operating-systems/windows-xp-vista/create-run-powershell-script/
# http://www.devcode4.com/article/powershell-remove-docker-containers-and-images

$selectedDockerImages = (docker images --all $DockerImage --quiet)
if ($selectedDockerImages.Count -gt 0) 
{
	foreach ($DockerImage in $selectedDockerImages)
	{
		docker images -q $DockerImage
		Write-Host ($DockerImage + " image was found") -ForegroundColor Green
	}
}
else {
	# show mesage that docker image does not exist
	Write-Host ($DockerImage + " image not exists")  -ForegroundColor Red
}