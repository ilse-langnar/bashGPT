# bash-gpt.sh 🚀

Welcome to **bash-gpt.sh**, the hacker's way to call OpenAI's GPT models from Bash! This script allows you to easily query the OpenAI API from anywhere, using the latest and greatest GPT models available💻.

## Dependencies 📦
Before you can start using **bash-gpt.sh**, you'll need to install a few *dependencies*. You can do this by running the following command:

`sudo apt-get update && sudo apt-get install -y rofi xclip curl jq`


This will install the following packages:

**rofi**: A window switcher, application launcher and dmenu replacement 🚪

**xclip**: A command line interface to the X11 clipboard 📋

**curl**: A tool to transfer data from or to a server 🌐

**jq**: A lightweight and flexible command-line JSON processor 🔍


## Usage 🤖
There are two main ways to use **bash-gpt.sh**: with a script and with a shortcut.

## Using **bash-gpt.sh** with a script 📜
1) Download the **bash-gpt.sh** file. 📥
2) Open the file and replace the default options (key, model and temperature) with your own. 🔑
3) Run the script by typing bash **bash-gpt.sh** in your terminal like: `bashGPT.sh "List me the top 10 games of all time"`. 🖥️
4) That's it! **bash-gpt.sh** will query the OpenAI API using your chosen model and temperature, and copy the generated text to your clipboard using xclip. 📋

## Using **bash-gpt.sh** with i3wm 🐧

1) Download the **bash-gpt.sh** file. 📥
2) Open the file and replace the default options (key, model and temperature) with your own. 🔑
3) Open your i3wm config file by typing nano ~/.config/i3/config in your terminal. 🖥️
4) Add the following line to your config file: `bindsym $mod+Shift+c exec bash bash-gpt.sh` 📝
5) Save the config file and restart i3wm. ♻️
6) Press `$mod+Shift+c` to launch **bash-gpt.sh**. 🚀

Now you can use **bash-gpt.sh** from anywhere in **i3wm** by pressing `$mod+Shift+c` and generating awesome text with OpenAI's GPT models! 🤖

## Contributing 💪
If you find any issues with **bash-gpt.sh** or want to contribute to the project, feel free to create an issue or a pull request on the Github repository. We welcome all contributions and suggestions! 🙏

## License 📄
BashGPT.sh is licensed under the MIT License. Use it, modify it, have fun with it! 😎
