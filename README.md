# balamOs
Pentesting/Forensics oriented Os based on ArchLinux with BlackArch repository
# Create your own image
To create your own image you will need to clone this repo, it doesnt contain all the files necesary because it would make it unecesarilly heavy.
```
git clone https://github.com/BiCH0/balamOs
```
The next step is to set yourself inside the repo dir
```
cd balamOs
```
Once inside you should see the following files:
WILL UPDATE WITH THE FILES
The next step is to copy the releng arch linux preset and rename it, to do so execute the following command in your working directory
```
cp -r /usr/share/archiso/profiles/releng . && mv releng liveiso
```
Now you will need the follwing files of the liveiso dir
## liveiso/pacman.conf
Append the following data to the end of the file
```
[blackarch]
SigLevel = Optional TrustAll
Include = /etc/pacman.d/blackarch-mirrorlist

[micro-aur]
SigLevel = Optional TrustAll
Server = file:///media/datos/Documents/HACKING/BalamOs/balamOs/customrepo/
```
## liveiso/profiledef.sh (Optional)
Edit the following lines, this wont affect the usage of the iso but you know, branding
```
iso_name="BalamOs"
iso_label="BALAM_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="BiCH0 <https://balamos.confugiradores.es>"
iso_application="Balam Os Live/Rescue DVD"
```
## liveiso/efiboot/loader/entries/
Edit all the files for branding


