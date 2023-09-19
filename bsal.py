from utils import *

current_menu = 0 # menu
end = [] # add stuff here to exit the game

while not end:
    if current_menu == 0:
        print(f"""
        [1] {langstr("menu__start")}
        [2] {langstr("menu__load")}
        [3] {langstr("menu__settings")}
        [4] {langstr("menu__quit")}
        """)
        choice = input("")
        match choice:
            case "1": pass
            case "2": pass
            case "3": current_menu = 3
            case "4": end.append("")
    elif current_menu == 3:
        print(f"""
        {langstr("menu__langcur")} {langstr("menu__lang")}
        {langstr("menu__langav")}
        """)
        for lange in lang_list:
            print(f"- {lange}")
        choice = input("")
        if choice != "q":
            langswitch(choice)
        else:
            current_menu = 0