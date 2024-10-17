██╗░░██╗███████╗██████╗░██╗░░░██╗░█████╗░
██║░██╔╝██╔════╝██╔══██╗██║░░░██║██╔══██╗
█████═╝░█████╗░░██████╔╝██║░░░██║██║░░██║
██╔═██╗░██╔══╝░░██╔══██╗██║░░░██║██║░░██║
██║░╚██╗███████╗██║░░██║╚██████╔╝╚█████╔╝
╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚═════╝░░╚════╝░

**A Terminal filing manager made with just "bash"!**

Meet keruo a fully useable file manager in the terminal with the exception of only being able to use it in your home directory! I love projects like [ranger](https://github.com/ranger/ranger) which is a vim inspired terminal file manager, and i wanted to take a shot of making my less than optimal version of it! 

## 📁 Features!
**``✏️ /Basic Usability/ 🗂️``**

- The ability to copy and paste files to different locations
- The ability to cut files to different locations
- The ability to rename files
- The ability to create new files
- The ability to remove files

All the functionality you need for a some what usable file manager!

## ⚠️ IMPORTANT

- When you try to enter a empty directory the choices come up together so if you want to say no to both you have to press (p) twice ! 
- When making a new file pressing enter will bring you back to your previous directory, you will have to go into the created files directory again to edit/view your previously created file



**KeyBindings**

- b | to go back to previous directory
- u | to rename a file
- c | to copy a file
- v | to paste a file
- n | to cut a file
- m | to delete a file
- y | to create a new file
- Enter | to go into a directory or into a file
- x or crtl+c | to Exit


  
Some other important information if you either delete, paste or cut a file you will have to go back a directory then go back into the directory you either added or removed a file from to show the updated changes!



## 📦 Needed Dependencies!
**``📔  /Needed Packages/ 📬``**

Sorry but i kinda lied... For the create new file feature and editing file feature to work you need [neovim](https://github.com/neovim/neovim)! Since thats the text editor i was using when making this!

Deb/Ubt based distros
```
$ sudo apt install neovim
```

Arch based distros
```
$ sudo pacman -S neovim
```

Fedora based distros
```
$ sudo dnf install neovim
```

CentOS/RHEL based distros
```
$ sudo yum install epel-release
$ sudo yum install neovim
```

openSUSE based distros
```
$ sudo zypper install neovim
```

NixOS
```
$ nix-env -iA nixpkgs.neovim
```

Void Linux
```
$ sudo xbps-install -S neovim
```

These are all the main distro commands to get neovim! Also to make sure you're able to use this correctly i would recommend using bash! This is the defualt shell for most distros!


The last thing you need is Nerd font symbols! 


[Symbols Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/NerdFontsSymbolsOnly.zip)


After your font is installed along with neovim we're free to continue the setup process!

## 🧰 Setting it up
**``🧩 /Install Steps/ 🛠️``**

First you want to grab the Keruo file this can either be down by simply copying or downloading the file directly out of this repo! Or by cloning this repo by using this command:

```
$ git clone https://github.com/juniepi/keruo
```

After doing one or the other you will have access to the Keruo file! We will need to move this file into your bin directory to give you access to use keruo in your terminal! 


Firstly lets cd into where you installed keruo! 

```
$ cd /Path/To/keruo.sh
```

once you're in the directory with keruo.sh we will need to give it execute permission! We will do this by using this command:

```
$ chmod +x keruo.sh
```

Once keruo is able to execute! We can move it into bin! We do this by using this command:

```
$ sudo mv keruo.sh /bin/keruo
```

Now Keruo should be in your bin! now you should be able to use this command in your terminal to use keruo!

```
$ keruo
```

You're now finished with the setup! Enjoy this scuffed file manager that only works in the home directory!
