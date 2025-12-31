# Used for handling start of the game
import std/strutils
import std/tables
import game

proc initCharacter* (g: Game, player_tuple: var tuple[name: string,
                                                           gender: Gender,
                                                           class: Class,
                                                           race: Race,
                                                           attr, skill: string
                                                           ]) =
    echo DIVIDER
    echo getTutorialKey(g, "game__tut_1")
    echo getTutorialKey(g, "game__tut_2")
    echo getTutorialKey(g, "game__tut_3")
    echo DIVIDER
    # name pick
    while player_tuple.name == "":
        echo getKey(g, "game__crq_1")
        let prompt = readLine(stdin)
        if prompt != "":
            player_tuple.name = prompt
        clearScreen()
    # gender pick
    while player_tuple.gender == VOIDG:
        echo getKey(g, "game__crq_2")
        echo getButtonKey(g, "gender__male") & " " & getButtonKey(g, "gender__female") & " "
        #TODO: v1.2: & echo getButtonKey(g, "gender__nonbinary")
        let prompt = readLine(stdin)
        let conv   = {
                      getKey(g, "gender__male").toLowerAscii:      getdGender["male"],
                      getKey(g, "gender__female").toLowerAscii:    getdGender["female"],
                      #TODO: v1.2: getKey(g, "gender__nonbinary").toLowerAscii: getdGender["nonbinary"]
                      }.toTable
        if prompt.toLowerAscii in conv:
            player_tuple.gender = conv[prompt.toLowerAscii]
        clearScreen()
    # race pick
    while player_tuple.race == VOIDR:
        echo getKey(g, "game__crq_3")
        echo DIVIDER
        var conv = newTable[string, Race]() # prompt comparison, Race
        for race_name in getdRace.keys:      # print race, then add to comparison table
            echo getButtonKey(g, "race__" & race_name)
            echo getKey(g, "race__" & race_name & "_descr")
            echo DIVIDER
            conv[getKey(g, ("race__" & race_name)).toLowerAscii] = getdRace[race_name]
        let prompt = readLine(stdin)
        if prompt.toLowerAscii in conv:
            player_tuple.race = conv[prompt.toLowerAscii]
        clearScreen()
    # class pick
    while player_tuple.class == VOIDC:
        echo getKey(g, "game__crq_4")
        echo DIVIDER
        var conv = newTable[string, Class]() # prompt comparison, Class
        for class_name in getdClass.keys:     # print class, then add to comparison table
            echo getButtonKey(g, "class__" & class_name)
            conv[getKey(g, ("class__" & class_name)).toLowerAscii] = getdClass[class_name]
        let prompt = readLine(stdin)
        if prompt.toLowerAscii in conv:
            player_tuple.class = conv[prompt.toLowerAscii]
        clearScreen()
    # # attribute pick
    # while player_tuple.attr == "":
    #     break
    # # skill pick
    # while player_tuple.skill == "":
    #     break

    # after all picks are done
    createCharacter(g, player_tuple.name, player_tuple.gender, player_tuple.race, player_tuple.class)
    # modifyAttributes(g.player, player_tuple.attr, 1)
    # modifySkills(g.player, player_tuple.skill, 1)