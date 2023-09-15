#preseted information
import random
import time
start = 0
quit = 0
load = 0
wait = 0
filenotfound = 0
settings_system = 2
tutorial_system = 0
#ładowanie systemu
try:
  loadsett = open ("settings.py","r")
  sett1 = loadsett.readline()
  sett2 = loadsett.readline()
  loadsett.close()
  settings_system = ''.join(sett1)
  tutorial_system = ''.join(sett2)
  settings_system = int(settings_system)
  tutorial_system = int(tutorial_system)
except FileNotFoundError:
  pass


#menu główne
print ('''|__) _|_    _ _ _   (_ |_  _  _| _     _   _  _  _|  |  . _ |_ |_ 
|__)(-|_\)/(-(-| )  __)| )(_|(_|(_)\)/_)  (_|| )(_|  |__|(_)| )|_ 
                                                         _/  
\n                                        version 0.1\n''')
while start == 0:
  menu = input ("\n[1] NOWA GRA\n[2] ZAŁADUJ GRĘ\n[3] OPCJE\n[4] ZAKOŃCZ GRĘ")
  if menu == "1":
    start = ("createcharacter")
  elif menu == "2":
    try:
      loadfile = open ("bsalsave.py","r")
      loadfile2 = open ("bsalesave.py","r")
      loadfile3 = open ("bsalqsave.py","r")
      start = 1
      load = 1
      break
    except FileNotFoundError:
      print ("Nie masz zapisanych gier!")
      time.sleep (1)
      continue
  elif menu == "3":
    while True:
      #opis + save
      if settings_system == 1:
        system_descr = "PC"
      elif settings_system == 2:
        system_descr = "Internet"
      else:
        system_descr = "Error"
        print ("Błąd wczytywania systemu gry - zignoruj")
      if tutorial_system == 0:
        tutorial = "Wyłączony"
      elif tutorial_system == 1:
        tutorial = "Włączony"
      else:
        tutorial = "Error"
        print ("Błąd wczytywania tutorialu gry - zignoruj")

      savesettings = open ("settings.py","w")
      settings_system = str(settings_system)
      tutorial_system = str(tutorial_system)
      option_save = (settings_system + "\n" + tutorial_system)
      savesettings.write (option_save)
      settings_system = int(settings_system)
      tutorial_system = int(tutorial_system)
      savesettings.close ()
      #opcje
      print ("\nTryb gry:",system_descr)
      print ("Tutorial:",tutorial)
      local = input ("\n[1] Przełącz tryb gry \n[2] Przełącz tutorial \n[3] Wyjdź z opcji")
      if local == "1":
        if settings_system == 1:
          settings_system = 2
        elif settings_system == 2:
          settings_system = 1
        continue
      elif local == "2":
        if tutorial_system == 0:
          tutorial_system = 1
          print ("\nInformacje tutorialowe będą od tej chwili wyświetlane z charakterystyczną obwódką: >>")
        elif tutorial_system == 1:
          tutorial_system = 0
        continue
      elif local == "3":
        break
    continue
  elif menu == "4":
    break
  else:
    continue

#---------------------stats-------------------------------
#podstawowe wartości postaci [bsalsave]
name = ""
gender = 0
race = 0
craft = 0
location = ""

hp = 100
sp = 1000
mp = 100
xp = 0
hp_level = 100
mp_level = 100
xp_level = 100
max_weight = 24
weight = 0
level = 1

strength = 8
dexterity = 8
intelligence = 8
endurance = 8
charisma = 8

bows = 1
swords = 1
guns = 1
castspelling = 0
trade = 1
connection = 0
repair = 0
healing = 0
lockpicking = 0
sneaking = 0
smithing = 0
herbalism = 0
vehicle_drive = 0
trapspotting = 0
survival = 0

pwr_tech = 0
pwr_magic = 0
pwr_conn = 0
pwr_chaos = 0

mainquest = 0
quests = []
done_quests = []

equip = []
used_equip = []
bank_equip = []
eq_attack = 2
eq_defence = 0
eq_mdefence = 0
eq_ammo = 0
eq_arrows = 0
eq_poisoning = 0
eq_money = 0
eq_bank = 0
eq_lockpicks = 0
eq_style = 0
eq_style2 = 0
eq_armor = 0
eq_maxarmor = 0

#------------------istotne-przypisania---------------------
item_info = 0
item_use = 0
lets_use = 0
dont_use = 0
throw_it = 0
taken_item = 0
inventory_error = 0
crouch = 0
openness = 0
dont_use2 = 0
armor_hp = 0
battle_equip = 0
tavern_key = 0
timer = 0
timer2 = 0
timer3 = 0
timer_time = 0
timer_time2 = 0
timer_time3 = 0

taken_money = []
taken_money2 = []
taken_lock = []
taken_lock2 = []
taken_ammo = []
taken_arrows = []
temp_chest = []
#skrzynie w grze
shelter_chest = ["500 monet","Zdobiona Strzelba", "Kolczuga"]
shelter_barrel = ["4 monety","15 wytrychów", "Słodka Bułka", "Śledź", "Śledź", "Śledź"]
evros_chest = ["300 monet","Jedwab"]
#--------------------encyclopaedia-------------------------
#nie jest to używana defka, a jedynie spis dostępnych przedmiotów z opisami
def encyclopaedia():
  print ("\n--------------ENCYCLOPAEDIA---------------\n")
  print ("x monet")
  print ("-----------------UŻYWALNE-----------------")
  print ("Korzonki")
  print ("[HP+2*survival]")
  print ("Słodka Bułka")
  print ("[HP+5]")
  print ("Śledź")
  print ("[HP+7]")
  print ("Pieczony Śledź")
  print ("[HP+18]")
  print ("Szczurze Mięso")
  print ("[HP+3*survival; survival = 0 -> poisoning]")
  print ("Pieczone Szczurze Mięso")
  print ("[HP+20]")
  print ("Woda")
  print ("[HP+3*survival, SP+15]")
  print ("Piwo")
  print ("[HP+8, SP-15, $=10]")
  print ("----------------SKŁADNIKI-----------------")
  print ("Podgrzana Woda")
  print ("Kwiat Hyerbitusa")
  print ("[leczniczy]")
  print ("----------------MIKSTURY------------------")
  print ("Odtrutka")
  print ("[poisoning -> off]")
  print ("Mała Mikstura Zdrowia")
  print ("[HP+25]")
  print ("Mała Mikstura Many")
  print ("[MP+25]")
  print ("----------------NARZĘDZIA-----------------")
  print ("Wytrych")
  print ("Kule")
  print ("Strzały")
  print ("Pergamin")
  print ("Pszenica")
  print ("Żelazo [W=2]")
  print ("Drewno [W=1]")
  print ("Jedwab [W=2]")
  print ("------------------BRONIE------------------")
  print ("Zardzewiały Nóż")
  print ("[style=1, A=4, W=1, $=8]")
  print ("Sierp")
  print ("[style=1, A=4, W=1, $=8]")
  print ("Rapier")
  print ("[style=1, A=10, W=1, $=35")
  print ("Bandycki Rewolwer")
  print ("[style=3, A=5, W=1, $=15")
  print ("Zdobiona Strzelba")
  print ("[style=3, A=22, W=2, $=120]")
  print ("Kostur Ognia")
  print ("[style=4, A=3, W=1, $=50]")
  print ("Kostur Ziemi")
  print ("[style=4, A=3, W=1, $=47]")
  print ("Kostur Połączenia")
  print ("[style=4, A=3, W=1, $=38]")
  print ("Kostur Chaosu")
  print ("[style=4, A=3, W=1, $=66 /zabroniony]")
  print ("Dynamit")
  print ("[A=25, $=30]")
  print ("-----------------PANCERZE-----------------")
  print ("Kolczuga*")
  print ("[DEF=+6, AHP = 50, W=1, $=55]")
  print ("*wszystkie zbroje mają wersję -uszkodzoną-")
  print ("[Uszkodzona wersja, DEF=0")
  print ("------------------ZWOJE-------------------")
  print ("Zwój Uzdrowienia")
  print ("[hp+20, MP-10, $=20]")
  print ("Zwój Ognistej Kuli")
  print ("[A=18, MP-32, $=24]")
  print ("-------KSIĄŻKI & GAZETY & PRZEPISY--------")
  print ("Gazeta Evros, 1.09.216 n.e.")
  print ("Przepis na Małą Miksturę Leczniczą")
  print ("-----------------WROGOWIE-----------------")
  print ("Pirat")
  print ("[LVL 1, HP = 70, DMG = 10, RNG-off")
  print ("Szczur")
  print ("[**^~]")
  print ("[LVL 1, HP = 15, DMG = 5, RNG-on")
  print ("-----------------ZADANIA------------------")
  print ("[1.1A] Porozmawiaj z kucharzem")
  print ("[1.1B] Przynieś słodką bułkę marynarzowi")
  print ("[2.1A] Zdobądź pergamin w Evros")
  print ("[2.1B] Przynieś pergamin do maga")
  print ("[2.2]* Praca na farmie Evros")
  print ("[2.3]*^ Praca dla zielarza Evros")
  print ("[2.4A] Zdobądź pergamin w Evros")
  print ("[2.4B] Wróć z jedwabiem do nieznajomego")
  print ("[2.4C] Przystąp do Gildii Złodziei")
  print ("[2.4X]! Wilczy Bilet do Gildii Złodziei")
  print ("-----")
  print ("[*] zadanie powtarzalne")
  print ("[^] zadanie bezwpisowe")
  print ("[!] istotne dla późniejszej akcji")

def inventory (inv_call):
  #efekty statystyczno-ekranowe, głównie
  moneyq = 0
  global lets_use
  global dont_use
  global throw_it
  global item_info
  global item_use
  global taken_item
  global eq_style
  global eq_style2
  global eq_armor
  global eq_maxarmor
  global eq_attack
  global eq_defence
  global eq_mdefence
  global eq_ammo
  global eq_arrows
  global eq_money
  global eq_lockpicks
  global eq_poisoning
  global hp
  global mp
  global sp
  global xp
  global weight
  global strength
  global dexterity
  global intelligence
  global endurance
  global charisma
  global bows
  global swords
  global guns
  global castspelling
  global trade
  global connection
  global repair
  global healing
  global lockpicking
  global smithing
  global herbalism
  global vehicle_drive
  global trapspotting
  global survival
  global pwr_tech
  global pwr_magic
  global pwr_conn
  global pwr_chaos
  global inventory_error
  global taken_money
  global taken_lock
  global taken_ammo
  global taken_arrows
  global armor_hp
  global dont_use2

  if inv_call == 1:
    #opis przedmiotu
    if item_info == "Korzonki":
      print ("[KORZONKI]")
      print ("[Drobne trawne zioła, chociaż więcej z nich korzyści dla zielarza niż zwykłego śmiertelnika]")
    elif item_info == "Słodka Bułka":
      print ("[SŁODKA BUŁKA]")
      print ("[Bułeczka z dżemem, pokryta miodową polewą]")
    elif item_info == "Śledź":
      print ("[ŚLEDŹ]")
      print ("[Całkiem smaczna ryba, regenerująca delikatnie zdrowie]")
    elif item_info == "Pieczony Śledź":
      print ("[PIECZONY ŚLEDŹ]")
      print ("[Dobrze przygotowany śledź, będący skarbem zarówno dla podniebienia, jak i zdrowia]")
    elif item_info == "Zardzewiały Nóż":
      print ("[ZARDZEWIAŁY NÓŻ]")
      print ("[Nadgryziony zębem czasu nóż, który chociaż mógłby swoją rdzą zakazić przeciwnika, prędzej się złamie przy zadawaniu ciosu]")
      print ("[A=4, W=1]")
    elif item_info == "Sierp":
      print ("[SIERP]")
      print ("[Sierp pozwala na ścinanie różnych zbóż, na przykład pszenicy]")
      print ("[A=4, W=1]")
    elif item_info == "Rapier":
      print ("[RAPIER]")
      print ("[Dość ciężki miecz, konstrukcji odpowiedniej do walk wszelakich - jednak najbardziej rozpowszechniony wśród marynarzy i piratów. Zadaje dość średnie obrażenia, będąc jednak mimo to skuteczny]")
      print ("[A=10, W=1]")
    elif item_info == "Bandycki Rewolwer":
      print ("[BANDYCKI REWOLWER")
      print ("[Dość słaby rewolwer najprostszej konstrukcji - popularny wśród bandytów, jako że skonstruowanie go nie jest najtrudniejszą sztuką]")
      print ("[A=5, W=1]")
    elif item_info == "Kolczuga":
      print ("[KOLCZUGA]")
      print ("[Całkiem niezły pancerz, złożony z nachodzących na siebie kółeczek żelaznych]")
      print ("[DEF=6]")
    elif item_info == "Uszkodzona Kolczuga":
      print ("[USZKODZONA KOLCZUGA]")
      print ("[Kolczuga, która już trochę przeżyła - bez naprawy wiele nią nie zdziałam]")
    elif item_info == "Zwój Uzdrowienia":
      print ("[ZWÓJ UZDROWIENIA]")
      print ("[Zwój pozwalający uleczyć się z ran]")
      print ("[MP-10]")
    elif item_info == "Zwój Ognistej Kuli":
      print ("[ZWÓJ OGNISTEJ KULI]")
      print ("[Jego użycie daje sporą przewagę w walce, posyłając na przeciwnika rozżarzoną kulę]")
      print ("[A=18, MP-32]")
    elif item_info == "Zdobiona Strzelba":
      print ("[ZDOBIONA STRZELBA]")
      print ("[Zadbana, bardzo dobra jakościowo strzelba, zdolna poważnie uszkodzić przeciwnika")
      print ("[A=22, W=2]")
    elif item_info == "Woda":
      print ("[WODA]")
      print ("[Woda może nieco orzeźwić umysł, jednak jej głównym celem jest bycie składnikiem mikstur i wszelkich zup]")
    elif item_info == "Podgrzana Woda":
      print ("[PODGRZANA WODA]")
      print ("[Myślę, że podgrzana woda lepiej służy, niż jej nie przegotowany odpowiednik]")
    elif item_info == "Pergamin":
      print ("[PERGAMIN]")
      print ("[Służy głównie do tworzenia książek i zwojów]")
    elif item_info == "Pszenica":
      print ("[PSZENICA]")
      print ("[Przydatna może dla młynarza do przerobienia na mąkę]")
    elif item_info == "Żelazo":
      print ("[ŻELAZO]")
      print ("[Służy do sztuki kowalskiej, wytwarzania jak i naprawiania broni i pancerzy]")
    elif item_info == "Drewno":
      print ("[DREWNO]")
      print ("[Drewno ma rozliczne zastosowania, ale najczęściej służy do rozpalenia ognia, bądź stolarstwa]")
    elif item_info == "Szczurze Mięso":
      print ("[SZCZURZE MIĘSO]")
      print ("[Surowe szczurze mięso jest raczej niezbyt dobre dla organizmu..]")
    elif item_info == "Pieczone Szczurze Mięso":
      print ("[PIECZONE SZCZURZE MIĘSO]")
      print ("[Pieczone mięso jest świetną potrawą, niezależnie z jakiego zwierzęcia ono jest]")
    elif item_info == "Odtrutka":
      print ("[ODTRUTKA]")
      print ("[Leczy ona zatrucia]")
    elif item_info == "Mała Mikstura Zdrowia":
      print ("[MAŁA MIKSTURA ZDROWIA]")
      print ("[Regeneruje ona punkty zdrowia]")
    elif item_info == "Mała Mikstura Many":
      print ("[MAŁA MIKSTURA MANY]")
      print ("[Regeneruje ona energię magiczną]")
    elif item_info == "Piwo":
      print ("[PIWO]")
      print ("[Trunek dobry, rzecz jasna, choć na dłuższą metę szkodliwy")
    elif item_info == "Kostur Ognia":
      print ("[KOSTUR OGNIA]")
      print ("[Pozwala walczyć czarami szkoły ognia magom]")
    elif item_info == "Kostur Ziemi":
      print ("[KOSTUR ZIEMI]")
      print ("[Pozwala walczyć czarami szkoły ziemi magom]")
    elif item_info == "Kostur Połączenia":
      print ("[KOSTUR POŁĄCZENIA]")
      print ("[Pozwala używać czarów połączenia kapłanom ormackim, jak i magom poświęconym magii połączenia]")
    elif item_info == "Kostur Chaosu":
      print ("[KOSTUR CHAOSU]")
      print ("[Daje możliwość wykorzystania najsilniejszej mocy w świecie Baedoor, siły chaosu]")
    elif item_info == "Dynamit":
      print ("[DYNAMIT]")
      print ("[Świetna rzecz, gdy przychodzi utorować sobie drogę w kopali, lub też.. wśród wrogów]")
    elif item_info == "Jedwab":
      print ("[JEDWAB]")
      print ("[Drogi materiał, który może służyć głównie do sprzedaży - chyba, że udałbym się z tym do tkacza]")
    elif item_info == "Kwiat Hyerbitusa":
      print ("[KWIAT HYERBITUSA]")
      print ("[Kwiat dość rozpowszechnionej rośliny o fioletowo-zielonej łodyżce. Zdaje się, że ma własności lecznicze")
    elif "Gazeta" in item_info or "Przepis" in item_info or "Księga" in item_info:
      books(item_info)
    else:
      pass


  elif inv_call == 2:
    #użycie przedmiotu, change+
    if item_use == "Korzonki":
      hp += 2*survival
      if 2*survival > 10:
        print ("Ah, czuję się lepiej")
      else:
        print ("Zjadłem korzonki, chociaż nie czuję dużego efektu")
    elif item_use == "Słodka Bułka":
      hp += 5
    elif item_use == "Śledź":
      hp += 7
    elif item_use == "Pieczony Śledź":
      hp += 18
    elif item_use == "Zwój Uzdrowienia":
      if mp < 10:
        print ("Nie masz odpowiednio dużo many!")
        inventory_error = 1
      elif pwr_tech > 10:
        print ("Jesteś zbytnio po technologicznej stronie, by używać tej broni")
        inventory_error = 1
      else:
        mp -= 10
        hp += 20
    elif item_use == "Zwój Ognistej Kuli":
      if battle_equip == 0:
        print ("Możesz użyć ten zwój tylko podczas walki!")
        inventory_error = 1
      elif mp < 32:
        print ("Nie masz odpowiednio dużo many!")
        inventory_error = 1
      elif pwr_tech > 10:
        print ("Jesteś zbytnio po technologicznej stronie, by używać tej broni")
        inventory_error = 1
      else:
        mp -= 32
        eq_attack = 18
    elif item_use == "Dynamit":
      if battle_equip == 0:
        print ("Możesz użyć ten zwój tylko podczas walki!")
        inventory_error = 1
      elif pwr_magic > 10:
        print ("Masz za wiele magicznej mocy do używania tej broni")
        inventory_error = 1
      else:
        eq_attack = 25
    elif item_use == "Woda":
      sp += 15
      hp += 3*survival
      if 3*survival > 10:
        print ("Ah, czuję się lepiej")
      else:
        pass
    elif item_use == "Podgrzana Woda":
      hp += 5 + 3*survival
    elif item_use == "Szczurze Mięso":
      if survival == 0:
        eq_poisoning = 1
        print ("...uh. Źle się czuję")
      else:
        hp += 3*survival
    elif item_use == "Pieczone Szczurze Mięso":
      hp += 20
      print ("Ah, czuję się dużo lepiej")
    elif item_use == "Odtrutka":
      if eq_poisoning > 1:
        eq_poisoning = 0
        print ("Ah, czuję się lepiej")
      else:
        print ("Nic nie czuję")
    elif item_use == "Mała Mikstura Zdrowia":
      hp += 25
    elif item_use == "Mała Mikstura Many":
      mp += 25
    elif item_use == "Piwo":
      hp += 8
      sp -= 15
    elif item_use == "Kwiat Hyerbitusa":
      eq_poisoning = 1
      print ("Uh, na surowo ta roślina nie jest zbyt dobra.. i dziwnie mi w żołądku")
    else:
      print ("Nie możesz użyć tego przedmiotu!")
      inventory_error = 1


  elif inv_call == 3:
    #włożenie przedmiotu, stats+
    if lets_use == "Zardzewiały Nóż":
      if eq_style == 0:
        eq_style = 1
        eq_attack = 4
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Sierp":
      if eq_style == 0:
        eq_style = 1
        eq_attack = 4
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Rapier":
      if eq_style == 0:
        eq_style = 1
        eq_attack = 10
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Bandycki Rewolwer":
      if eq_style == 0:
        if pwr_magic > 10:
          print ("Masz za wiele magicznej mocy do używania tej broni")
          inventory_error = 1
        else:
          eq_style = 3
          eq_attack = 5
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Zdobiona Strzelba":
      if eq_style == 0:
        if pwr_magic > 10:
          print ("Masz za wiele magicznej mocy do używania tej broni")
          inventory_error = 1
        else:
          eq_style = 3
          eq_attack = 22
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Kostur Ognia":
      if eq_style == 0:
        if pwr_tech > 10:
          print ("Jesteś zbytnio po technologicznej stronie, by używać tej broni")
          inventory_error = 1
        else:
          eq_style = 4
          eq_attack = 3
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Kostur Ziemi":
      if eq_style == 0:
        if pwr_tech > 10:
          print ("Jesteś zbytnio po technologicznej stronie, by używać tej broni")
          inventory_error = 1
        else:
          eq_style = 4
          eq_attack = 3
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Kostur Połączenia":
      if eq_style == 0:
        eq_style = 4
        eq_attack = 3
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Kostur Chaosu":
      if eq_style == 0:
        if pwr_tech > 10:
          print ("Jesteś zbytnio po technologicznej stronie, by używać tej broni")
          inventory_error = 1
        elif pwr_conn > 10:
          print ("Zbyt wiele w Tobie energii połączenia, by używać tej broni")
          inventory_error = 1
        elif pwr_chaos < -5:
          print ("Za dużo straciłeś energii chaosu, by używać tej broni")
          inventory_error = 1
        else:
          eq_style = 4
          eq_attack = 3
      else:
        print ("Najpierw zdejmij aktualnie używaną broń!")
        inventory_error = 1

    elif lets_use == "Kolczuga":
      if eq_style2 == 0:
        eq_style2 = 1
        eq_defence = 6
        eq_armor = 50
        eq_maxarmor = 50
      else:
        print ("Najpierw zdejmij aktualnie używany pancerz!")
        inventory_error = 1

    elif lets_use == "Uszkodzona Kolczuga":
      if eq_style2 == 0:
        eq_style2 = 1
      else:
        print ("Najpierw zdejmij aktualnie używany pancerz!")
        inventory_error = 1

    else:
      print ("Nie możesz założyć tego przedmiotu!")
      inventory_error = 1


  elif inv_call == 4:
    #zdjęcie przedmiotu, stats-
    if dont_use == "Zardzewiały Nóż":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Sierp":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Rapier":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Bandycki Rewolwer":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Zdobiona Strzelba":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Kostur Ognia":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Kostur Ziemi":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Kostur Połączenia":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Kostur Chaosu":
      eq_style = 0
      eq_attack = 2
    elif dont_use == "Kolczuga":
      if armor_hp < 100:
        inventory_error = 7
        dont_use2 = "Uszkodzona Kolczuga"
      else:
        pass
      eq_style2 = 0
      eq_defence = 0
      eq_armor = 0
      eq_maxarmor = 0
    elif dont_use == "Uszkodzona Kolczuga":
      eq_style2 = 0
      eq_defence = 0
      eq_armor = 0
      eq_maxarmor = 0
    else:
      print ("Nie możesz zdjąć tego przedmiotu!")
      inventory_error = 1


  elif inv_call == 5:
    #dodanie przedmiotu, weight+
    #$
    if not taken_money:
      if not taken_lock:
        if not taken_ammo:
          if not taken_arrows:
            equip.append (taken_item)
          else:
            taken_arrows = int(taken_arrows[0])
            eq_arrows = eq_arrows + taken_arrows
            taken_arrows = []
        else:
          taken_ammo = int(taken_ammo[0])
          eq_ammo = eq_ammo + taken_ammo
          taken_ammo = []
      else:
        taken_lock = int(taken_lock[0])
        eq_lockpicks = eq_lockpicks + taken_lock
        taken_lock = []
    else:
      taken_money = int(taken_money[0])
      eq_money = eq_money + taken_money
      taken_money = []
    #prawilne statystyki tutaj
    if taken_item == "Zardzewiały Nóż":
      weight += 1
    elif taken_item == "Sierp":
      weight += 1
    elif taken_item == "Rapier":
      weight += 1
    elif taken_item == "Bandycki Rewolwer":
      weight += 1
    elif taken_item == "Zdobiona Strzelba":
      weight += 2
    elif taken_item == "Kolczuga":
      weight += 1
    elif taken_item == "Uszkodzona Kolczuga":
      weight += 1
    elif taken_item == "Żelazo":
      weight += 2
    elif taken_item == "Drewno":
      weight += 1
    elif taken_item == "Jedwab":
      weight += 2
    elif taken_item == "Kostur Ognia":
      weight += 1
    elif taken_item == "Kostur Ziemi":
      weight += 1
    elif taken_item == "Kostur Połączenia":
      weight += 1
    elif taken_item == "Kostur Chaosu":
      weight += 1
    else:
      pass


  elif inv_call == 6:
    #wyrzucenie/schowanie przedmiotu, weight-
    equip.remove (throw_it)
    if throw_it == "Zardzewiały Nóż":
      weight -= 1
    elif throw_it == "Sierp":
      weight -= 1
    elif throw_it == "Rapier":
      weight -= 1
    elif throw_it == "Bandycki Rewolwer":
      weight -= 1
    elif throw_it == "Zdobiona Strzelba":
      weight -= 2
    elif throw_it == "Kolczuga":
      weight -= 1
    elif throw_it == "Uszkodzona Kolczuga":
      weight -= 1
    elif throw_it == "Żelazo":
      weight -= 2
    elif throw_it == "Drewno":
      weight -= 1
    elif throw_it == "Jedwab":
      weight -= 2
    elif throw_it == "Kostur Ognia":
      weight -= 1
    elif throw_it == "Kostur Ziemi":
      weight -= 1
    elif throw_it == "Kostur Połączenia":
      weight -= 1
    elif throw_it == "Kostur Chaosu":
      weight -= 1
    else:
      pass


#-----------------------books------------------------------
def spellbook():
  print ("------CZARY PIERWSZEGO KRĘGU------")
  print ("[Ogień]")
  print ("[1] Płonąca Mała Kula Ognia")
  print ("[Ziemia]")
  print ("[1] Kłujące Krzaki")
  print ("[Połączenie]")
  print ("[1] Pomniejsze Uzdrowienie")
  print ("[Chaos]")
  print ("[1] Wchłonięcie Duszy")

def herbalistbook():
  print ("[1][Przepis na Małą Miksturę Leczniczą]")
  print ("-Kwiat Hyerbitusa, Podgrzana Woda-")

def smithbook():
  pass

def locationbook():
  print ("-----------------------------")
  print ("[1] Statek 'Arennan'")
  print ("[2] Wyspa Evros")
  print ("   [2.1] Wybrzeże Evros")
  print ("   [2.2] Evros")
  print ("   [2.3] Pola Evros")
#-------------------------inne-----------------------------
#DEFYYY!!!
#------------------------load------------------------------
def loading():
  global name
  global gender
  global race
  global craft
  global location
  global hp
  global sp
  global mp
  global xp
  global hp_level
  global mp_level
  global xp_level
  global max_weight
  global weight
  global eq_attack
  global eq_defence
  global eq_mdefence
  global eq_ammo
  global eq_arrows
  global eq_poisoning
  global eq_money
  global eq_bank
  global eq_lockpicks
  global eq_style
  global eq_style2
  global eq_armor
  global eq_maxarmor
  global level
  global strength
  global dexterity
  global intelligence
  global endurance
  global charisma
  global bows
  global swords
  global guns
  global castspelling
  global trade
  global connection
  global repair
  global healing
  global lockpicking
  global sneaking
  global smithing
  global herbalism
  global vehicle_drive
  global trapspotting
  global survival
  global pwr_tech
  global pwr_magic
  global pwr_conn
  global pwr_chaos
  global mainquest
  global equip
  global used_equip
  global bank_equip
  global quests
  global done_quests
  #staty
  loadfile = open ("bsalsave.py","r")
  line1 = loadfile.readline()
  line2 = loadfile.readline()
  line3 = loadfile.readline()
  line4 = loadfile.readline()
  line5 = loadfile.readline()
  line6 = loadfile.readline()
  line7 = loadfile.readline()
  line8 = loadfile.readline()
  line9 = loadfile.readline()
  line10 = loadfile.readline()
  line11 = loadfile.readline()
  line12 = loadfile.readline()
  line13 = loadfile.readline()
  line14 = loadfile.readline()
  line15 = loadfile.readline()
  line16 = loadfile.readline()
  line17 = loadfile.readline()
  line18 = loadfile.readline()
  line19 = loadfile.readline()
  line20 = loadfile.readline()
  line21 = loadfile.readline()
  line22 = loadfile.readline()
  line23 = loadfile.readline()
  line24 = loadfile.readline()
  line25 = loadfile.readline()
  line26 = loadfile.readline()
  line27 = loadfile.readline()
  line28 = loadfile.readline()
  line29 = loadfile.readline()
  line30 = loadfile.readline()
  line31 = loadfile.readline()
  line32 = loadfile.readline()
  line33 = loadfile.readline()
  line34 = loadfile.readline()
  line35 = loadfile.readline()
  line36 = loadfile.readline()
  line37 = loadfile.readline()
  line38 = loadfile.readline()
  line39 = loadfile.readline()
  line40 = loadfile.readline()
  line41 = loadfile.readline()
  line42 = loadfile.readline()
  line43 = loadfile.readline()
  line44 = loadfile.readline()
  line45 = loadfile.readline()
  line46 = loadfile.readline()
  line47 = loadfile.readline()
  line48 = loadfile.readline()
  line49 = loadfile.readline()
  line50 = loadfile.readline()
  line51 = loadfile.readline()
  line52 = loadfile.readline()
  line53 = loadfile.readline()
  #joinsy
  loadfile.close()
  name = ''.join(line1)
  gender = ''.join(line2)
  race = ''.join(line3)
  craft = ''.join(line4)
  location = ''.join(line5)
  hp = ''.join(line6)
  sp = ''.join(line7)
  mp = ''.join(line8)
  xp = ''.join(line9)
  hp_level = ''.join(line10)
  mp_level = ''.join(line11)
  xp_level = ''.join(line12)
  max_weight = ''.join(line13)
  weight = ''.join(line14)
  eq_attack = ''.join(line15)
  eq_defence = ''.join(line16)
  eq_mdefence = ''.join(line17)
  eq_ammo = ''.join(line18)
  eq_arrows = ''.join(line19)
  eq_poisoning = ''.join(line20)
  eq_money = ''.join(line21)
  eq_bank = ''.join(line22)
  eq_lockpicks = ''.join(line23)
  eq_style = ''.join(line24)
  eq_style2 = ''.join(line25)
  eq_armor = ''.join(line26)
  eq_maxarmor = ''.join(line27)
  level = ''.join(line28)
  strength = ''.join(line29)
  dexterity = ''.join(line30)
  intelligence = ''.join(line31)
  endurance = ''.join(line32)
  charisma = ''.join(line33)
  bows = ''.join(line34)
  swords = ''.join(line35)
  guns = ''.join(line36)
  castspelling = ''.join(line37)
  trade = ''.join(line38)
  connection = ''.join(line39)
  repair = ''.join(line40)
  healing = ''.join(line41)
  lockpicking = ''.join(line42)
  sneaking = ''.join(line43)
  smithing = ''.join(line44)
  herbalism = ''.join(line45)
  vehicle_drive = ''.join(line46)
  trapspotting = ''.join(line47)
  survival = ''.join(line48)
  pwr_tech = ''.join(line49)
  pwr_magic = ''.join(line50)
  pwr_conn = ''.join(line51)
  pwr_chaos = ''.join(line52)
  mainquest = ''.join(line53)
  #inty, ścinki, cała reszta
  hp = int(hp)
  sp = int(sp)
  mp = int(mp)
  xp = int(xp)
  hp_level = int(hp_level)
  mp_level = int(mp_level)
  xp_level = int(xp_level)
  max_weight = int(max_weight)
  weight = int(weight)
  eq_attack = int(eq_attack)
  eq_defence = int(eq_defence)
  eq_mdefence = int(eq_mdefence)
  eq_ammo = int(eq_ammo)
  eq_arrows = int(eq_arrows)
  eq_poisoning = int(eq_poisoning)
  eq_money = int(eq_money)
  eq_bank = float(eq_bank)
  eq_lockpicks = int(eq_lockpicks)
  eq_style = int(eq_style)
  eq_style2 = int(eq_style2)
  eq_armor = int(eq_armor)
  eq_maxarmor = int(eq_maxarmor)
  level = int(level)
  strength = int(strength)
  dexterity = int(dexterity)
  intelligence = int(intelligence)
  endurance = int(endurance)
  charisma = int(charisma)
  bows = int(bows)
  swords = int(swords)
  guns = int(guns)
  castspelling = int(castspelling)
  trade = int(trade)
  connection = int(connection)
  repair = int(repair)
  healing = int(healing)
  lockpicking = int(lockpicking)
  sneaking = int(sneaking)
  smithing = int(smithing)
  herbalism = int(herbalism)
  vehicle_drive = int(vehicle_drive)
  trapspotting = int(trapspotting)
  survival = int(survival)
  pwr_tech = int(pwr_tech)
  pwr_magic = int(pwr_magic)
  pwr_conn = int(pwr_conn)
  pwr_chaos = int(pwr_chaos)
  mainquest = int(mainquest)
  if name.endswith("\n"):
    name = name[:-1]
  else:
    pass
  if gender.endswith("\n"):
    gender = gender[:-1]
  else:
    pass
  if race.endswith("\n"):
    race = race[:-1]
  else:
    pass
  if craft.endswith("\n"):
    craft = craft[:-1]
  else:
    pass
  if location.endswith("\n"):
    location = location[:-1]
  else:
    pass
  #ekwipunek
  loadfile2 = open ("bsalesave.py","r")
  for item in loadfile2:
    if item.endswith("\n"):
      item = item[:-1]
    equip.append (item)
  #ekwipunek2
  loadfile3 = open ("bsalusave.py","r")
  for item in loadfile3:
    if item.endswith("\n"):
      item = item[:-1]
    used_equip.append (item)
  #questy
  loadfile4 = open ("bsalqsave.py","r")
  for item in loadfile4:
    if item.endswith("\n"):
      item = item[:-1]
    quests.append (item)
  #zrobionequesty
  loadfile5 = open ("bsaldqsave.py","r")
  for item in loadfile5:
    if item.endswith("\n"):
      item = item[:-1]
    done_quests.append (item)
  #bank
  loadfile6 = open ("bsalbsave.py","r")
  for item in loadfile6:
    if item.endswith("\n"):
      item = item[:-1]
    bank_equip.append (item)

#------------------------save------------------------------
def save(): 
  global name
  global gender
  global race
  global craft
  global location
  global hp
  global sp
  global mp
  global xp
  global hp_level
  global mp_level
  global xp_level
  global max_weight
  global weight
  global eq_attack
  global eq_defence
  global eq_mdefence
  global eq_ammo
  global eq_arrows
  global eq_poisoning
  global eq_money
  global eq_bank
  global eq_lockpicks
  global eq_style
  global eq_style2
  global eq_armor
  global eq_maxarmor
  global level
  global strength
  global dexterity
  global intelligence
  global endurance
  global charisma
  global bows
  global swords
  global guns
  global castspelling
  global trade
  global connection
  global repair
  global healing
  global lockpicking
  global sneaking
  global smithing
  global herbalism
  global vehicle_drive
  global trapspotting
  global survival
  global pwr_tech
  global pwr_magic
  global pwr_conn
  global pwr_chaos
  global mainquest
  global equip
  global used_equip
  global bank_equip
  global quests
  global done_quests
  savefile = open ("bsalsave.py","w")
  savefile2 = open ("bsalesave.py","w")
  savefile3 = open ("bsalusave.py","w")
  savefile4 = open ("bsalqsave.py","w")
  savefile5 = open ("bsaldqsave.py","w")
  savefile6 = open ("bsalbsave.py","w")
  #zmiana typów int->str, błąd pythona w innym przypadku
  hp = str(hp)
  sp = str(sp)
  mp = str(mp)
  xp = str(xp)
  hp_level = str(hp_level)
  mp_level = str(mp_level)
  xp_level = str(xp_level)
  max_weight = str(max_weight)
  weight = str(weight)
  eq_attack = str(eq_attack)
  eq_defence = str(eq_defence)
  eq_mdefence = str(eq_mdefence)
  eq_ammo = str(eq_ammo)
  eq_arrows = str(eq_arrows)
  eq_poisoning = str(eq_poisoning)
  eq_money = str(eq_money)
  eq_bank = str(eq_bank)
  eq_lockpicks = str(eq_lockpicks)
  eq_style = str(eq_style)
  eq_style2 = str(eq_style2)
  eq_armor = str(eq_armor)
  eq_maxarmor = str(eq_maxarmor)
  level = str(level)
  strength = str(strength)
  dexterity = str(dexterity)
  intelligence = str(intelligence)
  endurance = str(endurance)
  charisma = str(charisma)
  bows = str(bows)
  swords = str(swords)
  guns = str(guns)
  castspelling = str(castspelling)
  trade = str(trade)
  connection = str(connection)
  repair = str(repair)
  healing = str(healing)
  lockpicking = str(lockpicking)
  sneaking = str(sneaking)
  smithing = str(smithing)
  herbalism = str(herbalism)
  vehicle_drive = str(vehicle_drive)
  trapspotting = str(trapspotting)
  survival = str(survival)
  pwr_tech = str(pwr_tech)
  pwr_magic = str(pwr_magic)
  pwr_conn = str(pwr_conn)
  pwr_chaos = str(pwr_chaos)
  mainquest = str(mainquest)
  saved_text = (name + "\n" + gender + "\n" + race + "\n" + craft + "\n" + location + "\n" + hp + "\n" + sp + "\n" + mp + "\n" + xp + "\n" + hp_level + "\n" + mp_level + "\n" + xp_level + "\n" + max_weight + "\n" + weight + "\n" + eq_attack + "\n" + eq_defence + "\n" + eq_mdefence + "\n" + eq_ammo + "\n" + eq_arrows + "\n" + eq_poisoning + "\n" + eq_money + "\n" + eq_bank + "\n" + eq_lockpicks + "\n" + eq_style + "\n" + eq_style2 + "\n" + eq_armor + "\n" + eq_maxarmor + "\n" + level + "\n" + strength + "\n" + dexterity + "\n" + intelligence + "\n" + endurance + "\n" + charisma + "\n" + bows + "\n" + swords + "\n" + guns + "\n" + castspelling + "\n" + trade + "\n" + connection + "\n" + repair + "\n" + healing + "\n" + lockpicking + "\n" + sneaking + "\n" + smithing + "\n" + herbalism + "\n" + vehicle_drive + "\n" + trapspotting + "\n" + survival + "\n" + pwr_tech + "\n" + pwr_magic + "\n" + pwr_conn + "\n" + pwr_chaos + "\n" + mainquest)
  savefile.write (saved_text)
  for item in equip:
    savefile2.write("%s\n" % item)
  for item in used_equip:
    savefile3.write("%s\n" % item)
  for item in quests:
    savefile4.write("%s\n" % item)
  for item in done_quests:
    savefile5.write("%s\n" % item)
  for item in bank_equip:
    savefile6.write("%s\n" % item)
  savefile.close ()
  savefile2.close ()
  savefile3.close ()
  savefile4.close ()
  savefile5.close ()
  savefile6.close ()
  print ("Gra została zapisana!")
  #na wszelki wypadek wracam str->int (gdyby save był tylko nerwowy i nie świadczył o końcu gry)
  hp = int(hp)
  sp = int(sp)
  mp = int(mp)
  xp = int(xp)
  hp_level = int(hp_level)
  mp_level = int(mp_level)
  xp_level = int(xp_level)
  max_weight = int(max_weight)
  weight = int(weight)
  eq_attack = int(eq_attack)
  eq_defence = int(eq_defence)
  eq_mdefence = int(eq_mdefence)
  eq_ammo = int(eq_ammo)
  eq_arrows = int(eq_arrows)
  eq_poisoning = int(eq_poisoning)
  eq_money = int(eq_money)
  eq_bank = float(eq_bank)
  eq_lockpicks = int(eq_lockpicks)
  eq_style = int(eq_style)
  eq_style2 = int(eq_style2)
  eq_armor = int(eq_armor)
  eq_maxarmor = int(eq_maxarmor)
  level = int(level)
  strength = int(strength)
  dexterity = int(dexterity)
  intelligence = int(intelligence)
  endurance = int(endurance)
  charisma = int(charisma)
  bows = int(bows)
  swords = int(swords)
  guns = int(guns)
  castspelling = int(castspelling)
  trade = int(trade)
  connection = int(connection)
  repair = int(repair)
  healing = int(healing)
  lockpicking = int(lockpicking)
  sneaking = int(sneaking)
  smithing = int(smithing)
  herbalism = int(herbalism)
  vehicle_drive = int(vehicle_drive)
  trapspotting = int(trapspotting)
  survival = int(survival)
  pwr_tech = int(pwr_tech)
  pwr_magic = int(pwr_magic)
  pwr_conn = int(pwr_conn)
  pwr_chaos = int(pwr_chaos)
  mainquest = int(mainquest)
  time.sleep (2)

#-------------------------menu-----------------------------
#menu, obrazek
def menu_image():
  if location == "Statek 'Arennan'":
    print ('''✺---------------------------------------------✺
|    ☁                    ☁                ☀  |
|-----------^^^---------------------------------|
|     ♒         ♒   __    ♒        ♒        |
|_____________________||________________________|
|                   oo||                        |
|░░░░░░░░░░░░░░░░░░░[]||[]░░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░|
✺---------------------------------------------✺''')
  elif location == "Wybrzeże Evros":
    print ('''✺-----------------------------------------------✺
|/|||||||||||||||====|||||||||||o|||o|||\    ☀  |
|[_____|X|___o_]|    |____|X|_||________|++++++++|
|░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░|
|________________________________________________|
|♒♒♒♒♒♒♒♒♒♒ |/////|♒♒♒♒♒♒♒♒♒♒|
|_____________________|/////|____________________|
|////////////////////////////////////////////////|
✺-----------------------------------------------✺''')
  elif location == "Evros":
    print ('''✺-----------------------------------------------✺
|                               /________________|
|___________________     <=||   |||[]|||||||[]||||
||||[]||||||||||||||\      ||   ||||||||||||||||||
|||||||||||_______|||\          |________________|
|//////////|[\ /]|///|          |///|[    ]|     |
|/[kowal]//|[ X ]|///|          |///|[^   ]| [+] |
|//////////|[/ \]|///|          |///|[    ]|     |
✺---------------------------------------------✺''')
  elif location == "Pola Evros":
    print ('''✺-----------------------------------------------✺
|     ☁                                    ☀    |
|________________________________________________|
|  ################[X]##       **^~              |
|░░#░░░░░░░░░░░░░░░░░░░#░░░░░░░░░░░░░░░░░░░░░░░░░|
|░░#|░|░|░|░|░|░░░░░░░░#░░░░░░░░░░░░░░░░░░░░░░░░░|
|░░#|░|░|░|░|░|░░░░░░░░#░░░░░░░░░░░░░░░░**^~░░░░░|
|░░#|░|░|░|░|░|░░░░░░░░#░░░░░░░░░░░░░░░░░░░░░░░░░|
✺-----------------------------------------------✺''')
  elif location == "Port Baedoor":
    print ('''✺---------------------------------------------✺
|       (|                    (|               |
|   _____|______         ______|______   ♒    |
|    \_________|          \__________|         |
|___________________o__________________________|
|░░|_||_|░░░░░░░░░░-|-░░░░░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░/\░░░░░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░|
✺---------------------------------------------✺''')
  elif location == "Bezludna Wyspa" or location == "Dom na Bezludnej Wyspie":
    print ('''✺---------------------------------------------✺
|       ☁         /#########\          ☀      |
|                  |[]  _    |                 |
|__________________|   | |   |_________________|
|░░░░░░░░░░░░░░░░░░░░░[  ]░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░░[   ]░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░░[   ]░░░░░░░░░░░░░░░░░░░░░|
|░░░░░░░░░░░░░░░░░░░░[    ]░░░░░░░░░░░░░░░░░░░░|
✺---------------------------------------------✺''')
  else:
    print ('''✺---------------------------------------------✺
|                                              |
|                                              |
|                                              |
|                Błąd obrazka                  |
|                                              |
|                                              |
|                                              |
✺---------------------------------------------✺''')   
#armor_hp
def basic_armor():
  #opisuje armor_hp, w przypadkach zarówno walki, jak i przeglądania postaci - czyli ten współczynnik, pokazujący procent siły pancerza. Istnieje jako def, by był aktualny w każdej sytuacji
  global eq_defence
  global eq_armor
  global eq_maxarmor
  global eq_style2
  global armor_hp
  if eq_style2 == 0:
    armor_hp = 0
  elif eq_style2 == 1:
    armor_hp = eq_armor/eq_maxarmor*100
    armor_hp = int(armor_hp)
    if armor_hp <= 0:
      if settings_system == 2:
        print ("\x1b[1;37;41m" + "Twój pancerz się zniszczył!" + "\x1b[0m")
      else:
        print ("[" + "Twój pancerz się zniszczył!" + "]")
      eq_defence = 0
      armor_hp = 0
    else:
      pass
  else:
    print ("Błąd ładowania pancerza (%)")

#menu, postac
def menu_postac():
  basic_armor()
  print ("Twoja postać:","\n\n[",name,"]\n",gender,"\n",race,"\n",craft,"\n")
  print ("Poziom", level, "\n")
  print ("-Punkty doświadczenia:",xp,"/",xp_level,"-")
  print ("-Wypoczęcie:",sp,"-")
  print ("[HP",hp,"/",hp_level,"][Mana",mp,"/",mp_level,"][Atak",eq_attack,"][Obrona",eq_defence,"(",armor_hp,"%)]")
  if eq_mdefence > 0:
    print ("[Obrona magiczna",eq_mdefence,"]")
  print ("---------------------")
  print ("[SIŁA",strength,"]\n[ZWINNOŚĆ",dexterity,"]\n[INTELIGENCJA",intelligence,"]\n[WYTRZYMAŁOŚĆ",endurance,"]""\n[CHARYZMA",charisma,"]")
  print ("\n[BROŃ BIAŁA",swords,"]\n[STRZELECTWO",bows,"]\n[BROŃ PALNA",guns,"]\n[RZUCANIE ZAKLĘĆ",castspelling,"]\n[SIŁA ZJEDNOCZENIA",connection,"]\n[HANDEL",trade,"]\n[NAPRAWA",repair,"]\n[LECZENIE",healing,"]\n[OTWIERANIE ZAMKÓW",lockpicking,"]\n[SKRADANIE",sneaking,"]\n[KOWALSTWO",smithing,"]\n[ZIELARSTWO",herbalism,"]\n[KIEROWANIE POJAZDAMI",vehicle_drive,"]\n[PUŁAPKI",trapspotting,"]\n[PRZETRWANIE",survival,"]")

#menu, ekwipunek
def equip_choose():
  global equip_choice
  global equip
  global used_equip
  global lets_use
  global dont_use
  global throw_it
  global item_info
  global item_use
  global inventory_error
  while True:
    inventory_error = 0
    print ("\nCiężar:", weight, "/", max_weight)
    print ("\nPieniądze:",eq_money)
    print ("Wytrychy:",eq_lockpicks)
    print ("Kule/strzały:", eq_ammo, "/", eq_arrows)
    print ("[EKWIPUNEK]")
    print (equip)
    print ("[UŻYWANE PRZEDMIOTY]")
    print (used_equip)
    equip_choice = input ("\n[1] Dowiedz się coś o przedmiocie \n[2] Użyj przedmiot \n[3] Nałóż przedmiot \n[4] Zdejmij przedmiot \n[5] Wyrzuć przedmiot \n[6] Wyjdź z menu ekwipunku")

    if equip_choice == "1":
      try:
        print ("[EKWIPUNEK]")
        print (equip)
        localx = input ()
        localx = int(localx)
        localx -= 1
        item_info = equip[localx]
        #informacje
        inventory(1)
        wait = input ("")
        continue
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")

    elif equip_choice == "2":
      try:
        print ("[EKWIPUNEK]")
        print (equip)
        local0 = input ()
        local0 = int(local0)
        local0 -= 1
        item_use = equip[local0]
        #statystyczna zmiana statów
        inventory(2)
        if inventory_error == 0:
          equip.remove (item_use)
        else:
          inventory_error = 0
        continue
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")
      
    elif equip_choice == "3":
      try:
        print ("[EKWIPUNEK]")
        print (equip)
        print ("[UŻYWANY EKWIPUNEK]")
        print (used_equip)
        local = input ("Którą rzecz chcesz nałożyć?")
        local = int(local)
        local -= 1
        lets_use = equip[local]
        #statystyczna opcja dodania statów
        inventory(3)
        if inventory_error == 0:
          equip.remove (lets_use)
          used_equip.append (lets_use)
        else:
          inventory_error = 0
        continue
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")

    elif equip_choice == "4":
      try:
        print ("[EKWIPUNEK]")
        print (equip)
        print ("[UŻYWANY EKWIPUNEK]")
        print (used_equip)
        local2 = input ("Którą rzecz chcesz zdjąć?")
        local2 = int(local2)
        local2 -= 1
        dont_use = used_equip[local2]
        #statystyczna opcja odejmowania statów
        inventory(4)
        if inventory_error == 0:
          used_equip.remove (dont_use)
          equip.append (dont_use)
        elif inventory_error == 7:
          used_equip.remove (dont_use)
          equip.append (dont_use2)
        else:
          inventory_error = 0
        continue
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")

    elif equip_choice == "5":
      try:
        print ("[EKWIPUNEK]")
        print (equip)
        local3 = input ("Którą rzecz chcesz wyrzucić?")
        local3 = int(local3)
        local3 -= 1
        throw_it = equip[local3]
        #wyrzucenie = vide inventory ()
        #statystyczna opcja odejmowania ciężaru
        inventory(6)
        continue
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")

    elif equip_choice == "6":
      break
    else:
      continue

#menu, mapa
def menu_mapa():
  print ("\n")
  if location == "Statek 'Arennan'" or location == "Wybrzeże Evros" or location == "Evros" or location == "Pola Evros":
    print ('''✺---------------------------------------------✺
| Λ Λ Λ Λ Λ Λ                      )           |
| Λ           ░░░░░░░░░░░░░░░░    (      ♒    |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)          |
| Λ ░░░░░░░░░░░░░░░░░░░  |  Baedoor ♖)        |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖⚓)         |
|Λ  ۩  ░░░░░░░░░░░░░░░░           (      ♒ ✖ |
| Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
✺---------------------------------------------✺''')
  elif location == "Port Baedoor":
    print ('''✺---------------------------------------------✺
| Λ Λ Λ Λ Λ Λ                      )           |
| Λ           ░░░░░░░░░░░░░░░░    (      ♒    |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)          |
| Λ ░░░░░░░░░░░░░░░░░░░  |  Baedoor ♖)        |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖✖)         |
|Λ  ۩  ░░░░░░░░░░░░░░░░           (      ♒    |
| Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
✺---------------------------------------------✺''')
  elif location == "Bezludna Wyspa" or location == "Dom na Bezludnej Wyspie":
    print ('''✺---------------------------------------------✺
| Λ Λ Λ Λ Λ Λ                      )           |
| Λ           ░░░░░░░░░░░░░░░░    (      ♒    |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)          |
| Λ ░░░░░░░░░░░░░░░░░░░  |  Baedoor ♖)        |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖⚓)         |
|Λ  ۩  ░░░░░░░░░░░░░░░░           (      ♒    |
| Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )       ✖   |
✺---------------------------------------------✺''')
  else:
    print ('''✺---------------------------------------------✺
| Λ Λ Λ Λ Λ Λ                      )           |
| Λ           ░░░░░░░░░░░░░░░░    (      ♒    |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)          |
| Λ ░░░░░░░░░░░░░░░░░░░  |     ✖    ♖)        |
|Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖⚓)         |
|Λ  ۩  ░░░░░░░░░░░░░░░░           (      ♒    |
| Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
✺---------------------------------------------✺''')

def menu_journey():
  global location
  global mainquest
  map_choice = 0
  print ("\nGdzie chcesz się udać?")
  while True:
    if location == "Statek 'Arennan'":
      if mainquest == 3:
        map_choice = input ("[1] Zejdź na ląd")
        if map_choice == "1":
          location = "Wybrzeże Evros"
          break
        else:
          break
      else: 
        map_choice = input ("[1] Niespecjalnie mam gdzie, jestem na statku")
        break

    elif location == "Wybrzeże Evros":
      map_choice = input ("[1] Wróć na statek \n[2] Wejdź do miasta")
      if map_choice == "1":
        if mainquest == 3:
          location = "Statek 'Arennan'"
          break
        else:
          print ("\nStatek zdążył odpłynąć, zanim zdążyłeś do niego dobiec!")
          print ("Mam jednak podejrzenie, że nie znalazłeś się tu, przywieziony przez statek.. łódeczka, której użyłeś, daje Ci odpłynąć na sekretną wyspę z powrotem")
          journey("Bezludna Wyspa",10)
          break
      elif map_choice == "2":
        location = "Evros"
        break
      else:
        break

    elif location == "Evros":
      map_choice = input ("[1] Wróć na wybrzeże \n[2] Udaj się na pola")
      if map_choice == "1":
        location = "Wybrzeże Evros"
        break
      elif map_choice == "2":
        location = "Pola Evros"
        local_rng = random.randint(1,4)
        if local_rng == 3:
          fight("Szczur",1,15,5,1,0,0)
        break
      else:
        break

    elif location == "Pola Evros":
      map_choice = input ("[1] Wróć do miasta")
      if map_choice == "1":
        location = "Evros"
        break
      else:
        break

    elif location == "Bezludna Wyspa":
      map_choice = input ("[1] Wejdź do domu \n[2] Przepłyń łódką do portu Baedoor \n[3] Przepłyń łódką do wyspy Evros")
      if map_choice == "1":
        location = "Dom na Bezludnej Wyspie"
        break
      elif map_choice == "2":
        print ("Nie czuję się na siłach na tak długą podróż...")
      elif map_choice == "3":
        journey("Wybrzeże Evros",10)
        break
      else:
        break

    elif location == "Dom na Bezludnej Wyspie":
      map_choice = input ("[1] Wyjdź z domu")
      if map_choice == "1":
        location = "Bezludna Wyspa"
        break
      else:
        break
    else:
      print ("Błąd lokacji!")
      break

#menu, dziennik
def menu_dziennik():
  global wait
  global quit
  dziennik_que = input ("Co chcesz zrobić? \n[1] Sprawdź dziennik \n[2] Zapisz grę \n[3] Zapisz grę i wyjdź \n[4] Wyjdź z gry")
  if dziennik_que == "1":
    print ("\n--------------------------")
    print ("[DZIENNIK ZADAŃ]")
    print (quests)
    wait = input("")
  elif dziennik_que == "2":
    save ()
    wait = 0
  elif dziennik_que == "3":
    save ()
    quit = 1
    wait = 0
  elif dziennik_que == "4":
    quit = 1
    wait = 0
  else:
    wait = 666

#---------------------usual-actions------------------------
def xp_add (xp_count):
  global xp
  global intelligence
  global level
  int_mod = int(intelligence/5)
  int_mod = int_mod/10
  int_mod = 1 + int_mod
  i_will_add = xp_count*int_mod
  i_will_add = int(i_will_add)
  xp = xp + i_will_add

def timering (timer_nb, time):
  #funkcja timera, odmierzającego czas
  global timer
  global timer2
  global timer3
  global timer_time
  global timer_time2
  global timer_time3
  if timer_nb == 1:
    timer = 1
    timer_time = time
  elif timer_nb == 2:
    timer2 = 1
    timer_time2 = time
  else:
    timer3 = 1
    timer_time3 = time

def small_buy (buy_item, money_needed):
  global eq_money
  global equip
  global taken_item
  if money_needed > eq_money:
    print ("Nie masz tylu pieniędzy!")
  else:
    eq_money = eq_money - money_needed
    taken_item = buy_item
    inventory (5)

def small_sell (sell_item, addmoney):
  global eq_money
  global equip
  global throw_it
  if sell_item in equip:
    eq_money = eq_money + addmoney
    throw_it = sell_item
    inventory (6)
  else:
    print ("Nie masz tego przedmiotu! [ew. błąd sprzedaży]")

def big_buy (buy_list):
  #buy_list ma być słownikiem = {item:value}
  while True:
    print ("\n[ZAKUP]----------------------------")
    print ("Ilość monet:",eq_money)
    print ("\nSKLEP:",buy_list)
    buy_choice = input ("\nKtóry przedmiot chcesz kupić? \n[1-..] Wybierz przedmiot | [litery] Anuluj")
    try:
      buy_choice = int(buy_choice)
      buy_choice -= 1
      buy_list2 = list(buy_list)
      print (buy_list2)
      want_buy = buy_list2[buy_choice]
      print (want_buy)
      want_value = buy_list[want_buy]
      print (want_value)
      small_buy (want_buy, want_value)
    except ValueError:
      break
  
def big_sell (sell_list):
  #sell_list ma być słownikiem = {item:value}
  while True:
    print ("\n[SPRZEDAŻ]----------------------------")
    print ("Ilość monet:",eq_money)
    print (equip)
    print ("\nSKLEP:",sell_list)
    sell_choice = input ("\nKtóry przedmiot chcesz sprzedać? \n[1-..] Wybierz przedmiot | [litery] Anuluj")
    try:
      sell_choice = int(sell_choice)
      sell_choice -= 1
      want_sell = equip[sell_choice]
      print (want_sell)
      try:
        sell_value = sell_list[want_sell]
        print (sell_value)
        small_sell (want_sell, sell_value)
      except KeyError:
        print ("Nie możesz sprzedać tego przedmiotu!")
        continue
    except ValueError:
      break

def big_countables (opt, amount, price):
  #big_buy dla czterech "countable" przedmiotów
  global eq_money
  global eq_lockpicks
  global eq_ammo
  global eq_arrows
  local = 1
  if price > eq_money:
    print ("Nie masz tyle pieniędzy!")
    local = 0
  else:
    eq_money = eq_money - price

  if local == 1:
    #opt1 = wytrychy
    if opt == 1:
      eq_lockpicks = eq_lockpicks + amount
    #opt2 = ammo
    elif opt == 2:
      eq_ammo = eq_ammo + amount
    #opt3 = arrows
    elif opt == 3:
      eq_arrows = eq_arrows + amount

def chests(chest_lock, chest_power):
  global temp_chest
  global equip
  global eq_money
  global eq_lockpicks
  global taken_item
  global throw_it
  global taken_money
  global taken_money2
  global taken_lock
  global taken_lock2
  global taken_ammo
  global taken_arrows
  if chest_lock == 1:
    lock (chest_power)
    if openness == 1:
      chest_lock = 0
    else:
      pass
  else:
    pass
  local = 0
  taken_item = 0
  while chest_lock == 0:
    print ("[SKRZYNIA]")
    print (temp_chest)
    print ("[EKWIPUNEK]")
    print (equip)
    local = input ("[1] Weź rzeczy \n[2] Odłóż rzeczy \n[3] Nic nie rób")
    print ("\n")
    if local == "1":
      print (temp_chest)
      if not temp_chest:
        print ("\nSkrzynia jest pusta!")
      else:
        taken_money = []
        taken_money2 = []
        taken_lock = []
        taken_lock2 = []
        local2 = input ("\nKtórą rzecz wziąć? [podaj jej numer]")
        local2 = int(local2)
        local2 -= 1
        taken_item = temp_chest[local2]
        #monety+wytrychy
        if 'monet' in taken_item:
          taken_money = [taken_item.strip(' monet') for taken_item in temp_chest if 'monet' in taken_item]
          taken_money2 = [taken_item.strip(' monety') for taken_item in temp_chest if 'monety' in taken_item]
          if 'moneta' in taken_item:
            taken_money = ["1"]
          else:
            pass
          if not taken_money2:
            pass
          else:
            taken_money = taken_money2

        elif 'wytrych' in taken_item:
          taken_lock = [taken_item.strip(' wytrychów') for taken_item in temp_chest if 'wytrychów' in taken_item]
          taken_lock2 = [taken_item.strip(' wytrychy') for taken_item in temp_chest if 'wytrychy' in taken_item]
          single_lock = [taken_item.split()]
          if 'wytrych' in single_lock:
            taken_lock = ["1"]
          else:
            pass
          if not taken_lock2:
            pass
          else:
            taken_lock = taken_lock2

        elif 'kul' in taken_item:
          if 'kula' in taken_item:
            taken_ammo = ["1"]
          else:
            taken_ammo = [taken_item.strip(' kul') for taken_item in temp_chest if 'kul' in taken_item]

        elif 'strzał' in taken_item:
          if 'strzała' in taken_item:
            taken_arrows = ["1"]
          else:
            taken_arrows = [taken_item.strip(' strzał') for taken_item in temp_chest if 'strzał' in taken_item]

        #c.d.
        inventory(5)
        temp_chest.remove (taken_item)

    elif local == "2":
      if not equip:
        print ("\nNie masz nic w swoim ekwipunku!")
      else:
        print (equip)
        local2 = input ("\nKtórą rzecz włożyć? [podaj jej numer]")
        local2 = int(local2)
        local2 -= 1
        throw_it = equip[local2]
        #wyrzucenie: vide inventory()
        inventory(6)
        temp_chest.append (throw_it)
    else:
      break

def sleeping():
  global hp
  global sp
  global mp
  global endurance
  global intelligence
  global pwr_magic
  global timer
  global timer2
  global timer3
  hp = 20 + endurance*10
  if hp < 100:
    hp = 100
  sp = 1000
  mp = 20 + intelligence*10 + pwr_magic*10
  if timer == 1 or timer2 == 1 or timer3 == 1:
    timer = 0
    timer2 = 0
    timer3 = 0

def crouching(detect):
  global crouch
  global sneaking
  global dexterity
  global sp
  sp -= 5
  cr = dexterity/2
  cr = int(cr)
  rng = random.randint(1,4)
  cr2 = sneaking*cr+rng
  if cr2 > detect:
    crouch = 1
    xp_add(10)
  else:
    crouch = 0
    sp -= 20
  #crouch = 1 pozytywne
  #crouch = 0 niepozytywne

def lock(lockpower):
  global lockpicking
  global openness
  global eq_lockpicks
  global sp
  while True:
    if eq_lockpicks == 0:
      print ("Nie masz wytrychów!")
      openness = 0
      break
    else:
      sp -= 5
      print ("\n[wytrychy:",eq_lockpicks,"]")
      local = input ("[1] Użyj wytrycha \n[2] Odejdź")
      if local == "1":
        rng = random.randint(1,5)
        lr = lockpicking*5+rng
        if lr >= lockpower:
          openness = 1
          xp_add (10)
          print ("Otworzyłem zamek!")
          break
        else:
          openness = 0
          eq_lockpicks -= 1
          print ("Złamałem wytrych...")
          continue
      else:
        openness = 0
        break

def smithing_use():
  global smithing
  global equip
  global eq_ammo
  global eq_arrows
  global sp
  global taken_item
  global throw_it
  print ("-------------------------------")
  local = input ("[1] Wykuj przedmiot \n[2] Napraw przedmiot \n[3] Odejdź")
  if local == "1":
    while True:
      print ("-------------------------------")
      print (equip)
      print ("-------------------------------")
      if smithing == 0:
        print ("Nie masz jeszcze odpowiednio dużych umiejętności!")
        break
      elif smithing > 1:
        print ("[1][RAPIER][Żelazo, Drewno]")
        print ("[2][POCISK -15-][Proch]")
        print ("[3][STRZAŁA -15-][Drewno]")
      i_will_smith = input ("\nWpisz numer broni, którą chcesz stworzyć")
      if i_will_smith == "1":
        if "Drewno" in equip and "Żelazo" in equip:
          throw_it = "Drewno"
          inventory(6)
          throw_it = "Żelazo"
          inventory(6)
          taken_item = "Rapier"
          inventory(5)
          sp -= 15
        else:
          print ("Brakuje Ci surowca!")
      elif i_will_smith == "2":
        if "Proch" in equip:
          throw_it = "Proch"
          inventory(6)
          eq_ammo += 15
          sp -= 15
        else:
          print ("Brakuje Ci surowca!")
      elif i_will_smith == "3":
        if "Drewno" in equip:
          throw_it = "Drewno"
          inventory(6)
          eq_arrows += 15
          sp -= 15
      else:
        "Podałeś zły numer"

  elif local == "2":
    if tutorial_system == 1:
      print (">> System naprawy jest w Between Shadows and Light oparty na dwóch umiejętnościach: naprawy, ale i kucia. Kucie reprezentuje te wszystkie naprawy, które wciąż wymagają umiejętności kowalstwa - z kolei naprawa potrzebna jest głównie do technologicznej części broni i pancerzy (jak i również do maszyn) <<")
    while True:
      print ("-------------------------------")
      print (equip)
      question = input ("[1-...] Wpisz numer przedmiotu do naprawy \n[A] Anuluj")
      try:
        question = int (question)
        question -= 1
        repairing_item = equip[question]
      except IndexError or ValueError:
        print ("Błędnie podałeś numer!")

      if repairing_item == "Uszkodzona Kolczuga":
        if "Żelazo" in equip and smithing > 0:
          sp -= 10
          throw_it = "Żelazo"
          inventory(6)
          throw_it = "Uszkodzona Kolczuga"
          inventory(6)
          taken_item = "Kolczuga"
          inventory(5)
        elif "Żelazo" in equip:
          print ("Za słabo obyłeś się z kowalstwem, by naprawić ten przedmiot")
        else:
          print ("Nie masz żelaza potrzebnego do naprawy!")
      else:
        print ("Nie możesz naprawić tego przedmiotu!")

  else:
    pass

def herbalism_use():
  global herbalism
  global temp_chest
  global equip
  global sp
  global taken_item
  global throw_it
  temp_chest = []
  if tutorial_system == 1:
    print (">> Pamiętaj, że możesz eksperymentować, nie znając przepisów - tak samo, jak znając przepis, może nie udać Ci się stworzyć mikstury, jeśli brak Ci umiejętności <<")
    print (">> Wkładając składniki do przetworzenia, pamiętaj, że po spróbowaniu zrobienia mikstury - jak i również przy wyjściu z laboratorium - wszystkie składniki zostają stracone. Rzecz jasna, gdy będziesz miał odpowiednie składniki, przetworzenie ich da Ci miksturę, której potrzebujesz <<")
  while True:
    print ("\n----------------------------------")
    print ("Używane składniki:",temp_chest)
    print ("\n[1] Dodaj/weź składniki \n[2] Spróbuj stworzyć miksturę \n[3] Odejdź")
    local = input ("")
    print ("\n")
    if local == "1":
      chests(0,0)
    elif local == "2":
      sp -= 5
      if "Kwiat Hyerbitusa" and "Podgrzana Woda" in temp_chest:
        print ("Stworzyłeś małą miksturę zdrowia!")
        taken_item = "Mała Mikstura Zdrowia"
        inventory(5)
        xp_add (5)
        temp_chest = []
      else:
        print ("Niestety, nie udało się stworzyć mikstury")
        temp_chest = []
    else:
      break

def cooking(cook_fry):
  #cook_fry: 1-ognisko, 2-ognisko z garnkiem
  global temp_chest
  global equip
  global sp
  global taken_item
  global throw_it
  if tutorial_system == 1:
    print (">> Gotowanie i pieczenie to nie lada sztuka, a odpowiednie składniki w rękach dobrego kucharza mogą zdziałać cuda. W grze możesz wybierać między gotowaniem a pieczeniem - zależnie, czy jesteś jedynie przy ognisku, czy może jest przy nim garnek. Z kolei gdy włączysz którąkolwiek z opcji, zasada jest podobna - kładąc odpowiednie składniki na 'szali', możesz je ugotować lub upiec, by służyły Ci lepiej. Z reguły rzeczy upieczone są smaczniejsze i lepiej leczą, z kolei zaś ugotowana woda daje Ci możliwości wykorzystania ziół, i nie zatrucia się przy okazji <<")
  print ("[1] Upiecz coś")
  if cook_fry == 2:
    print ("[2] Ugotuj coś")
  print ("[3] Odejdź")
  local = input("")
  if local == "1":
    temp_chest = []
    if tutorial_system == 1:
      print (">> Dość istotna uwaga: piec możesz jedną rzecz naraz. Nie kładź więc do upieczenia więcej niż jedną rzecz, gdyż możesz stracić niepotrzebnie to, co chciałeś upiec. Nie bez kozery mówi się, że 'upiec dwie pieczenie na jednym ogniu' to sztuka - sztuka raczej niedostępna wielu <<")
    while True:
      print ("\n----------------------------------")
      print ("Używane składniki:",temp_chest)
      print ("\n[1] Dodaj/weź składnik \n[2] Spróbuj upiec składnik \n[3] Odejdź")
      local2 = input ("")
      print ("\n")
      sp -= 5
      if local2 == "1":
        chests(0,0)
      elif local2 == "2":
        if "Szczurze Mięso" in temp_chest:
          print ("Upiekłeś szczurze mięso!")
          taken_item = "Pieczone Szczurze Mięso"
          inventory(5)
          xp_add (5)
          temp_chest = []
        else:
          print ("Niestety, nie udało się nic upiec!")
          temp_chest = []
      else:
        break
    pass
  elif local == "2":
    temp_chest = []
    while cook_fry == 2:
      print ("\n----------------------------------")
      print ("Używane składniki:",temp_chest)
      print ("\n[1] Dodaj/weź składniki \n[2] Spróbuj ugotować składniki \n[3] Odejdź")
      local3 = input ("")
      print ("\n")
      sp -= 5
      if local3 == "1":
        chests(0,0)
      elif local3 == "2":
        #woda na samym końcu!! [by nie gotować wody zawsze przy zupach]
        if "Woda" in temp_chest:
          print ("Ugotowałeś wodę")
          taken_item = "Podgrzana Woda"
          inventory(5)
          temp_chest = []
          xp_add (2)
        else:
          print ("Niestety, nie udało się nic ugotować!")
          temp_chest = []
      else:
        break
    pass
  else:
    pass

def journey(destination,distance):
  global sp
  global location
  tiredness = int(distance*15/endurance)
  sp = sp - tiredness
  location = destination

def books(book_name):
  print ("------------------------------")
  print ("[",book_name,"]")
  print ("------------------------------")
  if book_name == "Gazeta Evros, 1.09.216 n.e.":
    print ("Niesłychane wieści! Słynny zabójca Czarny Wąs, grasujący nieprzerwanie od miesięcy w Baedoor, został pojmany przez straże. Wszystko zawdzięczamy naszemu dzielnemu redaktorowi, który odkrył demaskujące go szczegóły")
    print ("Wieści z granicy donoszą o wzmożonej aktywności południowych ludów, zagrażających bezpieczeństwu naszego Imperium. W związku z tym wysłane zostały przez Zarządcę trzy nowo wyszkolone oddziały")
    print ("Ekspansja szkodników na wyspie Evros graniczy już ze stanem alarmowym. Ta plaga szczurów może poważnie uszkodzić główne źródło dochodu wyspy - rolnictwo")
  elif book_name == "Przepis na Małą Miksturę Leczniczą":
    print ("Kwiat Hyerbitusa, Podgrzana Woda")
  else:
    pass

def banking():
  global eq_money
  global eq_bank
  global equip
  global bank_equip
  global temp_chest
  eq_bank = int(eq_bank)
  while True:
    print ("[BANK]------------------------------")
    print ("Pieniądze:",eq_money)
    print ("Depozyt pieniężny:",eq_bank)
    print ("Depozyt:",bank_equip)
    local_bank = input ("[1] Złóż pieniądze do depozytu \n[2] Wyciągnij pieniądze \n[3] Zarządzaj depozytem przedmiotów \n[4] Wyjdź z banku")
    if local_bank == "1":
      local_add = input ("Ile monet chcesz wpłacić?")
      try:
        local_add = int(local_add)
        if local_add > eq_money:
          print ("Nie masz tylu pieniędzy!")
        else:
          eq_money = eq_money - local_add
          eq_bank = eq_bank + local_add
      except ValueError:
        pass
    elif local_bank == "2":
      local_minus = input ("Ile monet chcesz wypłacić?")
      try:
        local_minus = int(local_minus)
        if local_minus > eq_bank:
          print ("Nie masz tyle zdepozytowanych pieniędzy!")
        else:
          eq_bank = eq_bank - local_minus
          eq_money = eq_money + local_minus
      except ValueError:
        pass
    elif local_bank == "3":
      temp_chest = bank_equip
      chests(0,0)
      bank_equip = temp_chest
    else:
      break

def cast_spelling():
  global mp
  global hp
  global pwr_magic
  global pwr_tech
  global pwr_chaos
  global pwr_conn
  global eq_attack
  global eq_defence
  global castspelling
  global used_equip
  mod_magic = int (pwr_magic/2 - pwr_tech/2)
  mod_chaos = int (pwr_chaos/2 - pwr_conn/2 - pwr_tech/2)
  mod_conn = int (pwr_conn/2 - pwr_chaos/2 - pwr_tech/2)

  if 3 > castspelling > 0:
    print ("[1 KRĄG]--------------------")
    if "Kostur Ognia" in used_equip:
      local1 = input ("[1][Płonąca Mała Kula Ognia][A=15][MP-20]")
      if local1 == "1":
        if mp >= 20:
          mp -= 20
          eq_attack = 15 + mod_magic
        else:
          print ("Masz za mało many!")
      else:
        pass
    elif "Kostur Ziemi" in used_equip:
      local2 = input ("[1][Kłujące Krzaki][A=8][MP-9]")
      if local2 == "1":
        if mp >= 9:
          mp -= 9
          eq_attack = 8 + mod_magic
        else:
          print ("Masz za mało many!")
      else:
        pass
    elif "Kostur Połączenia" in used_equip:
      local3 = input ("[1][Pomniejsze Uzdrowienie][HP+20][MP-10]")
      if local3 == "1":
        if mp >= 10:
          mp -= 10
          hp = hp + 20 + mod_conn
        else:
          print ("Masz za mało many!")
      else:
        pass
    elif "Kostur Chaosu" in used_equip:
      local4 = input ("[1][Wchłonięcie duszy][A=40][HP-25][MP-30]")
      if local4 == "1":
        if mp >= 30:
          mp -= 30
          hp -= 25
          eq_attack = 40 + mod_chaos
        else:
          print ("Masz za mało many!")
      else:
        pass

    else:
      print ("Nie wiem, jakim cudem dostałeś się tutaj, ale wystąpił błąd łączenia używanego kosturu z dostępnymi dla niego czarami")

  elif castspelling > 3:
    print ("Masz za dobre umiejętności, poproś o pomoc twórcę gry")
  else:
    print ("Nie jesteś dostatecznie uzdolniony do rzucania zaklęć!")
    pass

def loot (enemy_name):
  global temp_chest
  global xp
  if enemy_name == "Ranny Pirat":
    temp_chest = ["Bandycki Rewolwer","20 monet","5 kul"]
    xp_add (18)
  elif enemy_name == "Pirat":
    temp_chest = ["Rapier","15 monet","2 wytrychy"]
    xp_add (22)
  elif enemy_name == "Szczur":
    temp_chest = ["Szczurze Mięso","moneta"]
    xp_add (5)
  else:
    print ("Błąd ładowania ekwipunku przeciwnika")

def fight (en_name, en_lvl, en_hp, en_dmg, rng, i_crouch, crouch_value):
  global hp
  global sp
  global swords
  global guns
  global bows
  global dexterity
  global strength
  global eq_attack
  global eq_defence
  global eq_arrows
  global eq_ammo
  global eq_style
  global eq_armor
  global start
  global crouch
  global pwr_tech
  global pwr_magic
  global pwr_chaos
  global pwr_conn
  global battle_equip
  global armor_hp
  win = 0
  attack_error = 0

  while win == 0:
    if i_crouch == 0:
      print ("[1] Zaatakuj przeciwnika")
    else:
      print ("[1] Zaatakuj przeciwnika")
      print ("[2] Spróbuj zaatakować z ukrycia")
    first_decision = input ("")
    #walka prawdziwa
    if first_decision == "1":
      turn = 0
      while win == 0:
        mod_tech = int (pwr_tech/2 - pwr_magic/3)
        sp -= 5
        basic_armor()
        turn += 1
        print ("\n[",turn,"]-------------------------------")
        print ("[",en_name,"]")
        print ("[Wrogie HP",en_hp,"]")
        print ("----------------------")
        print ("[HP",hp,"][Atak",eq_attack,"][Obrona",eq_defence,"(",armor_hp,"%)]")
        if eq_style == 2:
          if eq_arrows <= 0:
            print ("Brak amunicji! Zmień koniecznie broń")
            attack_error = 1
          else:
            pass
        elif eq_style == 3:
          if eq_ammo <= 0:
            print ("Brak amunicji! Zmień koniecznie broń")
            attack_error = 1
          else:
            pass
        else:
          pass
        print ("----------------------")
        print ("[1] Atak zwyczajny")
        if eq_style == 1:
          print ("[2] Atak z unikiem")
          print ("[3] Większy zamach")
          print ("[4] Defensywna taktyka")
        elif eq_style == 2 or eq_style == 3:
          print ("[5] Strzał z wycofaniem się")
          print ("[6] Precyzyjny strzał")
        elif eq_style == 4:
          print ("[7] Użyj zaklęcia")
        print ("[8] Użyj zwoju/broni wybuchowej")
        print ("[9] Zobacz ekwipunek")
        last_decision = input ("")
        #typy ataków i ich wyprowadzenie
        
        if last_decision == "1":
          if attack_error == 0:
            if eq_style == 2:
              eq_arrows -= 1
            elif eq_style == 3:
              eq_ammo -= 1
            att_rng = random.randint (1,2)
            def_rng = random.randint (0,2)
            att = eq_attack + att_rng*swords
            print ("Zadaliśmy",att,"obrażeń!")
            deff = eq_defence + def_rng
          else:
            att = 2
            print ("Zadaliśmy",att,"obrażeń!")
            deff = eq_defence

        elif last_decision == "2":
          if eq_style == 1:
            att_rng = random.randint (-2, 0)
            att = eq_attack + att_rng
            print ("Zadaliśmy",att,"obrażeń!")
            deff = random.randint (0,dexterity)
          else:
            pass

        elif last_decision == "3":
          if eq_style == 1:
            att_rng = random.randint (2, strength)
            att = eq_attack + att_rng
            print ("Zadaliśmy",att,"obrażeń!")
            deff = 0
          else:
            pass
        
        elif last_decision == "4":
          if eq_style == 1:
            att_rng = random.randint (-2, 0)
            def_rng = random.randint (2, endurance)
            att = eq_attack + att_rng
            print ("Zadaliśmy",att,"obrażeń!")
            deff = eq_defence + def_rng
          else:
            pass

        elif last_decision == "5":
          okay = 0
          if eq_style == 2:
            eq_arrows -= 1
            okay = 1
          elif eq_style == 3:
            eq_ammo -= 1
            okay = 2
          elif attack_error == 1:
            okay = 0
          else:
            pass
          deff = eq_defence
          if okay == 1:
            att_rng = random.randint (1,2)
            att = eq_attack + att_rng*bows
            print ("Zadaliśmy",att,"obrażeń!")
          elif okay == 2:
            att_rng = random.randint (1,2)
            att = eq_attack + att_rng*guns + mod_tech
            if att < 0:
              att = 0
            print ("Zadaliśmy",att,"obrażeń!")
          else:
            pass

        elif last_decision == "6":
          okay = 0
          if eq_style == 2:
            eq_arrows -= 1
            okay = 1
          elif eq_style == 3:
            eq_ammo -= 1
            okay = 2
          elif attack_error == 1:
            okay = 0
          else:
            pass
          def_rng = random.randint (-2,0)
          deff = eq_defence + def_rng
          if okay == 1:
            att_rng = random.randint (0, bows*3)
            att = eq_attack + att_rng
            print ("Zadaliśmy",att,"obrażeń!")
          elif okay == 2:
            att_rng = random.randint (0, guns*3)
            att = eq_attack + att_rng + mod_tech
            if att < 0:
              att = 0
            print ("Zadaliśmy",att,"obrażeń!")
          else:
            pass

        elif last_decision == "7":
          if eq_style == 4:
            temp_attack = eq_attack
            temp_defence = eq_defence
            cast_spelling()
            att = eq_attack
            deff = eq_defence
            eq_attack = temp_attack
            eq_defence = temp_defence
            if att < 0:
              att = 0
          else:
            pass
          
        elif last_decision == "8":
          battle_equip = 1
          temp_attack = eq_attack
          temp_defence = eq_defence
          equip_choose()
          att = eq_attack
          deff = eq_defence
          eq_attack = temp_attack
          eq_defence = temp_defence
          battle_equip = 0

        elif last_decision == "9":
          equip_choose()
          continue

        else:
          pass

        #win
        en_hp = en_hp - att
        if en_hp <= 0:
          win = 1
          break

        #część przeciwnika
        if rng == 1:
          rnumgen = random.randint (0,level*2)
          en_attack = en_dmg + rnumgen - deff
        else:
          en_attack = en_dmg - deff
        if en_attack < 0:
          en_attack = 0
        else:
          pass
        print ("Otrzymaliśmy",en_attack,"punktów obrażeń!")
        hp = hp - en_attack
        if eq_defence > 0:
          eq_armor = eq_armor - deff
        else:
          pass

        #lose
        if hp <= 0:
          win = 2
          break

    elif first_decision == "2":
      if i_crouch == 1:
        crouching(crouch_value)
        if crouch == 1:
          print ("Atak z zaskoczenia się powiódł!")
          win = 1
          break
        else:
          print ("Niestety, nie udało mi się")
          i_crouch = 0
          continue
      else:
        continue
    else:
      continue

  while win == 1:
    print ("Ekwipunek przeciwnika")
    loot(en_name)
    chests(0,0)
    break

  if win == 2:
    start = "death"
    print ("Zginąłęś....")
  else:
    pass

#------------------------quests----------------------------
def m_quest1 ():
  print ("\n---------------------------------------------------------------")
  time.sleep (1)
  print ("Podróżuję już długo, płynąc na okręcie 'Arennan' do portu Baedoor... kto wie, ile dni już minęło na nieznośnym oczekiwaniu lądu. Wiem tylko, że gdy do niego dotrę, zmieni się wszystko. Czekają na mnie możliwości, nie to co w tym zadupiu, w którym się urodziłem. Eh, to było okropne, gnić na tej małej wsi, marząc o wielkim świecie. Ale teraz już jestem na statku.. dzięki bogom, że kapitan był tak miły, by mnie przyjąć za darmo.")
  wait = input("")
  print ("Tak czy inaczej, powinienem się rozejrzeć po tym statku. Może ktoś mi powie coś więcej ciekawego")
  wait = input("")
  if tutorial_system == 1:
    print ("\n>> Tak więc Twoja przygoda się rozpoczęła! Za chwilę trafisz w pierwsze miejsce wydarzeń, jak i również wyświetli Ci się główne menu gry - z którego to będziesz korzystać później do samego końca <<")
    wait = input("")
    print ("\n>> Pierwszy fragment menu to krótkie podsumowanie najważniejszych informacji: gdzie się znajdujesz, ile punktów zdrowia posiadasz, jak bardzo obciąża Cię ekwipunek. Ta część menu nie służy więc niczemu ponadto, ale bywa użyteczna w sprawdzaniu najistotniejszych rzeczy <<")
    wait = input("")
    print ("\n>> Bardziej interesuje nas jednak kolejna część menu - ta, w której wypisane są poszczególne opcje. Wygląda ona tak:")
    time.sleep (4)
    print ("\n[POSTAC] [EKWIPUNEK] [LOKACJA] [MAPA] [DZIENNIK]")
    time.sleep (2)
    print ("...i ta część służy Ci do nawigacji w grze przez większość czasu - wszelkie inne zdarzenia wywoływane są w zależności od tego, co dokonasz za pomocą tego menu, wpisując odpowiednią komendę i potwierdzając Enterem <<")
    wait = input("")
    print (">> Najważniejsze wśród tych opcji są: ekwipunek i lokacja. Dzięki temu pierwszemu możesz zarządzać swoimi rzeczami (używać przedmiotów, sprawdzać ich stan), a za pomocą drugiego - sprawdzać, co lokacja, w której jesteś, ma do zaoferowania <<")
    wait = input("")
    print (">> 'Postać' [zalecane jest wpisywać bez polskich znaków, gdyż gra ich nie rozumie] pokazuje nam szczegółowe informacje dotyczące naszej postaci - nie daje nam ona jednak żadnej możliwości zmiany czegokolwiek, będąc jedynie częścią informacyjną")
    wait = input("")
    print (">> Mapą zajmiemy się później; z kolei dziennik pozwala Ci na sprawdzenie zadań, których zobowiązałeś/aś się podjąć; a ponadto możesz za jego pomocą zapisać lub wyłączyć grę <<")


  else:
    pass

def m_quest2 ():
  global mainquest
  time.sleep(2)
  print ("\n---------------------------------------------------------------")
  time.sleep(1)
  print ("Nagle...")
  time.sleep(1)
  print ("...zaatakowali nas piraci!")
  print ("Słyszę szczęk broni dookoła, na pokładzie zapanował okropny chaos..")
  time.sleep (5)
  print ("Widzę, że kapitana atakuje od tyłu jeden z tych rzezimieszków!")
  print ("Muszę stawić mu czoła, próbując walczyć tym, cokolwiek mam przy sobie")
  time.sleep (6)
  if tutorial_system == 1:
    print (">> Za chwilę pojawi się panel walki - jest on raczej intuicyjny. Powinniśmy jednak napomknieć o tym, że są różne rodzaje ataku - zależne od aktualnie trzymanej broni. Każdy z nich ma inną charakterystykę, skupiającą się na innej taktyce walki <<")
    print (">> Jeżeli do tej pory nie korzystałeś z ekwipunku, i nie dobyłeś broni (poprzez 'włożenie jej na siebie'), uczyń to teraz, wybierając w drugim menu '9' <<")
    time.sleep (8)
  else:
    pass
  fight ("Ranny Pirat",1,40,5,0,0,0)
  if start != "death":
    mainquest = 3
    m_quest3 ()
  else:
    pass

def m_quest3 ():
  global hp
  global hp_level
  print ("Ocaliłem kapitana przed śmiercią, niestety, w ferworze walki nie zdołał tego nawet zauważyć.. walka jednak dobiega końca, bo pozostały już tylko niedobitki przeciwników")
  wait = input ("")
  print ("Walka wygasła wręcz zupełnie, więc postanowiłem udać się do kajuty.. nie mam ochoty rozmawiać z przejętymi pasażerami statku, którzy ledwo po walce, zaczęli dyskutować o wszystkich szczegółach...")
  hp = hp_level
  time.sleep (7)
  print ("Obudziło mnie uderzenie statku.. jeżeli to nie kolejny atak, to znaczy, że zapewne dobiliśmy do jakiejś przystani. Powinienem się rozejrzeć i zejść na ląd")
  if tutorial_system == 1:
    print ("\n>> W tej części gry będziesz potrzebować ostatniego elementu: mapy. System mapy możesz w każdej chwili uruchomić w głównej części gry, wpisując po prostu odpowiednie hasło: zasada jego działania jest bliźniaczo podobna do pozostałych części menu. Mapa pozwala Ci na przemieszczanie się między większymi i mniejszymi fragmentami lokacji - dzięki temu jesteś w stanie odkrywać kolejne miejsca, połączone z Twoim obecnym miejscem pobytu <<")
  else:
    pass

#--------------------location-options----------------------
def locate_ship_arennan():
  global eq_money
  global location
  global quests
  global done_quests
  global taken_item
  global throw_it
  global crouch
  global tavern_key
  local = 0
  tavern_key = 0
  while True:
    print ("\n[1] Porozmawiaj z szarobrodym mężczyzną \n[2] Porozglądaj się po pokładzie \n[3] Popatrz się na widoki \n[4] Porozmawiaj z kapitanem \n[5] Nie rób nic")
    if "Porozmawiaj z kucharzem" in quests:
      print ("[6] Zejdź do kucharza")
    else:
      pass
    locate = input("")
    time.sleep (1)
    lol_kidding = 0
    while locate == "1":
      if lol_kidding == 0:
        if "Porozmawiaj z kucharzem" in done_quests:
          wait = "1"
        else:
          wait = input ("\nOh, witaj, nieznajomy. Czy my się znamy? \n[1] Eee.. nie, raczej nie \n[2] Tak, jak najbardziej!")
      else:
        wait = "1"
      if wait == "1":
        print ("\nW takim razie o co chodzi?")
        print ("[1] Nie mam grosza przy duszy, mógłbyś mi pomóc? \n[2] W sumie nie wiem, co ja tu robię...")
        if local == 1:
          print ("[3] Co to za wyspa przed nami?")
        elif "Przynieś słodką bułkę marynarzowi" in quests and "Słodka Bułka" in equip:
          print ("[4] Mam dla Ciebie bułkę!")
        else:
          pass
        wait = input ("")
        time.sleep (1)
        if wait == "1":
          print ("\nCóż, niespecjalnie mogę Ci pomóc, sam jestem w podobnej sytuacji")
          time.sleep (1)
          if "Porozmawiaj z kucharzem" in done_quests:
            pass
          else:
            print ("Z drugiej strony, mam nożyk na zbyciu.. ale nie dam Ci go za darmo, rzecz jasna")
            wait = input ("Chcesz go kupić, czy wolisz coś dla mnie zrobić? \n[1] Kupić \n[2] Zrobię coś dla Ciebie")
            if wait == "1":
              print ("W porządku, daj mi 7 monet")
              small_buy ("Zardzewiały Nóż",7)
            elif wait == "2":
              print ("\nNo dobra. W takim razie, skocz może do kucharza - znajduje się pod pokładem - i weź od niego słodką bułkę. Zgłodniałem, tak tutaj będąc.. ale chcę stać na warcie, by kapitan miał o mnie dobre zdanie. Pasuje?")
              wait = input ("[1] No jasne! \n[2] E, chyba sobie tego oszczędzę")
              if wait == "1":
                print ("\nSuper. Czekam na Ciebie w takim razie!")
                quests.append ("Porozmawiaj z kucharzem")
                break
              else:
                pass
            else:
              break
          wait = input("")
        elif wait == "2":
          print ("\nJa tym bardziej nie wiem, musisz do tego dojść sam, nieznajomy!")
          wait = input("")
          break
        elif wait == "3":
          if local == 1:
            print ("\nAh, ta wyspa.. cóż, to Evros, miejsce, w którym osiadła jedna z pierwszych grup osadników przypływająca w te okolice. Obecnie traktujemy ten kawałek lądu jako ostatnie miejsce na uzupełnienie zapasów, sprzedaż towarów, jak i po prostu odpoczynek. Polecam karczmę 'Pod Złotym Szczurem', serwują tam wyborne wino!")
            wait = input("")
            break
          else:
            pass
        elif wait == "4":
          if "Przynieś słodką bułkę marynarzowi" in quests and "Słodka Bułka" in equip:
            print ("\nO, przyniosłeś mi bułkę! Dziękuję po stokroć. Proszę, masz tu obiecany nożyk")
            time.sleep(2)
            quests.remove ("Przynieś słodką bułkę marynarzowi")
            done_quests.append ("Przynieś słodką bułkę marynarzowi")
            xp_add(8)
            throw_it = "Słodka Bułka"
            inventory (6)
            taken_item = "Zardzewiały Nóż"
            inventory (5)
            break
          else:
            pass
        else:
          continue
      else:
        print ("\nHaha, nie oszukasz starego Sama. Może już wzrok nie ten, ale nadal pamiętam perfekcyjnie każdą osobę, z którą rozmawiałem.")
        lol_kidding = 1
    if locate == "2":
      if eq_money < 3:
        print ("\nPrzeglądając pokład, zdołałeś znaleźć kilka monet")
        eq_money += 3
      else:
        print ("\nNie znalazłeś już nic ciekawego")
    elif locate == "3":
      print ("\nWidzisz przed sobą ogrom wody, rozpostarty wokół statku - w oddali majaczy niewielka wyspa, będąca, jak Ci się zdaje, przystankiem, o który statek zahaczy, kierując się do celu")
      local = 1
      continue
    elif locate == "4":
      print ("\nAh, witaj. Będę miał pewną rzecz dla Ciebie, ale porozmawiamy o tym, jak dopłyniemy do celu")
      wait = input ("[1] Ah, rozumiem.. w porządku")
      if wait == "1":
        break
      elif wait == "cheat":
        print ("\nMówisz, żeby Cię wysadzić na tej wyspie, której nie widać...? Cóż, mogę spełnić Twoje życzenie...")
        time.sleep (2)
        print ("\nWysadzono mnie na malutkiej wysepce, na której wydaje się, nikogo nie ma - jest ona tak mała, że domek znajdujący się na jej szczycie, wydaje się być jedyną rzeczą, która tutaj jest, poza kilkunastoma drzewami..")
        location = "Bezludna Wyspa"
        wait = input ("")
        break
    elif locate == "5":
      break
    elif locate == "6":
      while "Porozmawiaj z kucharzem" in quests:
        print ("Schodzisz na dolny pokład, do miejsca, w którym pracuje kucharz.. widzisz ryby porozkładane po półkach, i kilka bułek")
        time.sleep (1)
        local = input ("[1] Spróbuj ukraść bułkę \n[2] Poproś o bułkę \n[3] Nic nie rób")
        if local == "1":
          crouching (5)
          if crouch == 1:
            taken_item = "Słodka Bułka"
            inventory (5)
            quests.remove ("Porozmawiaj z kucharzem")
            done_quests.append ("Porozmawiaj z kucharzem")
            quests.append ("Przynieś słodką bułkę marynarzowi")
            print ("\nUdało mi się ukraść bułkę")
            time.sleep (2)
          else:
            print ("Przyłapałem Cię, bratku! Normalnie dałbym Ci bułkę, jednak za karę jej nie dostaniesz")
            quests.remove ("Porozmawiaj z kucharzem")
            done_quests.append ("Porozmawiaj z kucharzem")
            break
        elif local == "2":
          print ("\nMówisz, żeby Ci dać bułkę? Ah, masz, synku, naciesz się nią")
          time.sleep(1)
          taken_item = "Słodka Bułka"
          inventory (5)
          quests.remove ("Porozmawiaj z kucharzem")
          done_quests.append ("Porozmawiaj z kucharzem")
          quests.append ("Przynieś słodką bułkę marynarzowi")
        else:
          break
    else:
      continue

def locate_shelter_island():
  global equip
  global temp_chest
  global shelter_barrel
  global eq_lockpicks
  local = 0
  print ("Stoję na pomoście, od którego wychodzi drobna ścieżka w kierunku domu.. nie ma tu wiele więcej")
  while True:
    locate = input ("\n[1] Porozglądaj się po terenie \n[2] Przejrzyj beczki na pomoście \n[3] Nic nie rób")
    if locate == "1":
      print ("\nZnalazłem jakieś dziwne korzonki, nic poza tym")
      equip.append ("Korzonki")
      continue
    elif locate == "2":
      print ("\nOtwarłem beczkę")
      eq_lockpicks += 1
      temp_chest = shelter_barrel
      chests(0,0)
      shelter_barrel = temp_chest
    else:
      break

def locate_shelter_home():
  global equip
  global temp_chest
  global shelter_chest
  print ("\nWchodzisz do domu, widząc, że drzwi nie stawiają oporu.. jest nieco zaniedbany, i widać, że dawno tu nikt nie mieszkał. Jednak wygląda to całkiem przytulnie. Mógłbym sobie tu urządzić dom.")
  wait = input ("")
  print ("Wnętrze jest niewielkie, jednak wypełnione jest mnóstwem rzeczy, jak gdyby ktoś, kto tu mieszkał, zupełnie nie przejmował się tymi ograniczeniami. W kącie stoi łóżko, przy którym stoi stoliczek, a tuż obok niego - skrzynia. Przy jedynym dostępnym oknie jest biurko, z jakąś otwartą księgą.")
  while True:
    local = input ("\n[1] Przeczytaj księgę \n[2] Zbadaj skrzynię \n[3] Prześpij się \n[4] Nic nie rób")
    time.sleep (1)
    if local == "1":
      print ("\nAh, witaj, czytający to.. zapewne trafiłeś do mojego domu, który tym samym stał się Twoim w tej chwili. Nie martw się, strudzony wędrowcze, ja tu już nie mieszkam. Możesz więc użyć mojej chatki, jakkolwiek zechcesz - przechowuj swoje rzeczy w skrzyni, śpij, jedz, gotuj czy wytwarzaj narzędzia. Pamiętaj tylko, że przedmioty ze skrzyni znikną, gdy opuścisz grę - więc nie zapomnij ich zabrać przed wyjściem! \nAh, i właśnie... w skrzyni są też złote monety i broń, która będzie Ci pewnie miłą pomocą na początku. Opiekuj się nimi dobrze!")
      wait = input ("")
      continue
    elif local == "2":
      print ("\nOtworzyłem skrzynię!")
      temp_chest = shelter_chest
      chests(0,0)
      shelter_chest = temp_chest
      continue
    elif local == "3":
      print ("\nAh, w takim razie się prześpię..")
      sleeping()
      continue
    elif local == "4":
      break

def locate_evros_port():
  global equip
  global eq_money
  global quests
  global done_quests
  global castspelling
  global tavern_key
  global lockpicking
  global sneaking
  global eq_lockpicks
  global throw_it
  global crouch
  print ("Wybrzeże pokryte jest skałami, które jedynie w części portowej zanikają - zapewne, zmienione tak przez mieszkańców wyspy. Z doku, do którego przybił nasz statek, ciągnie się szeroka ulica, prowadząca wgłąb małego miasta. Przy wybrzeżu widać tawernę, jak i również kilka budynków magazynowych. Kręci się tu też trochę marynarzy i ludzi różnego rodzaju")
  while True:
    print ("\n[1] Wejdź do tawerny 'Pod Złotym Szczurem'\n[2] Odwiedź sklep z magicznym symbolem na szyldzie \n[3] Porozmawiaj z marynarzem w niebiesko-białym ubraniu \n[4] Podejdź do bogato ubranego chłopaka \n[5] Spróbuj wejść do magazynu \n[6] Nic nie rób")
    local = input ("")
    if local == "1":
      print ("Wchodzisz do tawerny, przepełnionej wymieszanym zapachem piwa i potu. Grupki marynarzy siedzą przy stołach, rozmawiając na różne tematy, czasami grając w karty bądź rechocząc z nieśmiesznych żartów rzucanych przez towarzyszy")
      while True:
        print ("[1] Kup coś u gospodarza")
        if tavern_key == 0:
          print ("[2] Zamów noc w gospodzie")
        else:
          print ("[3] Idź do pokoju")
        local_tav = input ("")
        if local_tav == "1":
          big_buy({"Piwo":8})
        elif local_tav == "2":
          if tavern_key == 0:
            print ("\nNoc w tawernie kosztuje 8 sztuk złota")
            local_sl = input ("[1] Kupuję \n[2] Rezygnuję")
            if local_sl == "1":
              if eq_money >= 8:
                eq_money -= 8
                tavern_key = 1
              else:
                print ("Nie masz tylu pieniędzy!")
            else:
              continue
          else:
              continue
        elif local_tav == "3":
          if tavern_key == 1:
            sleeping()
            print ("\nObudziłeś się wypoczęty!")
            tavern_key = 0
          else:
            print ("Nie masz klucza do pokoju!")
        else:
          break
    elif local == "2":
      print ("Witaj pod 'Magicznym Wywarem' w Evros, sklepem z najtańszymi cenami, przyjacielu! Czego potrzebujesz?")
      print ("[1] Chciałbym coś kupić \n[2] Mogę Ci jakoś pomóc? \n[3] Ee... co to za szarlatańskie sztuczki sprzedajesz? \n[4] Nic specjalnego..")
      if "Zdobądź pergamin w Evros" in quests and "Pergamin" in equip or "Przynieś pergamin do maga" in quests and "Pergamin" in equip:
        print ("[5] Mam dla Ciebie pergamin!")
      else:
        pass
      local_shop = input ("")
      if local_shop == "1":
        big_buy ({"Zwój Uzdrowienia":18,"Zwój Ognistej Kuli":20, "Kostur Ognia":45, "Kostur Ziemi":44, "Kostur Połączenia":35, "Odtrutka":15, "Mała Mikstura Many":12, "Mała Mikstura Zdrowia":14})
      elif local_shop == "2":
        if "Zdobądź pergamin w Evros" in quests:
          print ("Cóż, na razie przynieś mi materiały")
        elif "Zdobądź pergamin w Evros" in done_quests:
          print ("Wybacz, ale nie potrzebuję nic więcej")
        else:
          print ("Hm.. w sumie jest pewna rzecz. Wczoraj tak się wciągnąłem w testowanie nowych czarów, że brakło mi zwojów - przez co niedługo nie będę miał towaru do sprzedaży! Może.. przyniósłbyś mi pergamin?")
          local_q = input ("[1] Chętnie! \n[2] Chyba nie..")
          if local_q == "1":
            quests.append ("Zdobądź pergamin w Evros")
            print ("Dziękuję! Pergamin powinieneś dostać w sklepie z różnościami w głębi miasta.. powiedz, że przychodzisz ode mnie, to dostaniesz go na mój rachunek")
          else:
            continue
      elif local_shop == "3":
        print ("To żadne sztuczki, mój drogi. Magia istnieje naprawdę, i myślę, że spotkasz niedługo ludzi, którzy Ci to udowodnią. Ale może lepiej uwierzyć, zanim ktoś przypali Ci ubranie swoim kosturem?")
        wait = input("")
        print ("Skoro pytasz się o takie rzeczy, to najwidoczniej nie wiesz, na jakich zasadach działa nasz świat. Otóż - są tutaj siły, którym podlega każda istota: magia i technologia. Obie się wzajemnie wykluczają, więc nie możesz być magiem używającym silnych broni palnych: więc im bardziej kierujesz się w jedną stronę, tym bardziej zamykasz sobie drugą")
        wait = input("")
        print ("Magia zaś jest specyficzną sztuką - używając jej, możesz daleko zajść. Jednak by ją uprawiać, potrzebujesz odpowiedniego kosturu: dzięki niemu możesz zarówno używać magii w walce, jak i tworzyć silniejsze zwoje magiczne, niedostępne mniej obeznanym z magią osobom")
        wait = input("")
        if "Zdobądź pergamin w Evros" in quests or "Zdobądź pergamin w Evros" in done_quests:
          pass
        else:
          print ("Jeżeli chcesz, mogę Cię nauczyć używać kosturów i magii.. ale wpierw wyświadcz mi przysługę, hm?")
          local_q = input ("[1] Chętnie! \n[2] Chyba nie..")
          if local_q == "1":
            quests.append ("Zdobądź pergamin w Evros")
            print ("Dziękuję! Potrzebuję pergaminu. Powinieneś go dostać w sklepie z różnościami w głębi miasta.. powiedz, że przychodzisz ode mnie, to dostaniesz go na mój rachunek")
          else:
            continue
      elif local_shop == "5":
        if "Zdobądź pergamin w Evros" in quests and "Pergamin" in equip:
          local_go = 1
          quests.remove ("Zdobądź pergamin w Evros")
          done_quests.append ("Zdobądź pergamin w Evros")
          done_quests.append ("Przynieś pergamin do maga")
        elif "Przynieś pergamin do maga" in quests and "Pergamin" in equip:
          local_go = 1
          quests.remove ("Przynieś pergamin do maga")
          done_quests.append ("Przynieś pergamin do maga")
        else:
          local_go = 0
        if local_go == 1:
          equip.remove("Pergamin")
          print ("Oh, dziękuję ślicznie! Wreszcie będę mógł dalej tworzyć pergaminy do celów sprzedaży")
          print ("Zasłużyłeś na nagrodę, zatem pozwól, że nauczę Cię podstawowych zasad rzucania czarów")
          castspelling += 1
        else:
          continue
      else:
        break
    elif local == "3":
      print ("Witaj, nieznajomy")
      local_3 = input ("[1] Co jest tu ciekawego do obejrzenia? \n[2] Żegnaj")
      if local_3 == "1":
        print ("Wiesz, jesteśmy w Evros.. tutaj niespecjalnie jest cokolwiek do obejrzenia, bo to wyspa do bólu praktyczna. Jest wybrzeże dla przepływających statków, jest miasto z dość typową dla niego zabudową, są wreszcie pola za miastem. Jeżeli uważasz bieganie po sklepach za fajne, to polecam sklepy - jest ich tu przyzwoita ilość. Jeżeli zaś lubisz trochę alkoholu we krwi, to mamy tu tawernę")
      else:
        pass
    elif local == "4":
      print ("Witaj")
      local_4 = input ("[1] Kim jesteś? \n[2] Mogę coś dla Ciebie zrobić? \n[3] Żegnaj")
      if local_4 == "1":
        print ("Kim jestem? To niezbyt chyba Ci potrzebne..")
        time.sleep(2)
        print ("Ale jeśli nalegasz. Dominic le Velga, z rodu Velgów. Doglądam tu załadunku statku mojego ojca, nic więcej")
      elif local_4 == "2":
        print ("Zrobić? Doceniam chęci, ale nie sądzę, żebym czegoś potrzebował od Ciebie")

      else:
        pass
    elif local == "5":
      if "Dostań się do magazynu Evros" in quests or "Wróć z jedwabiem do nieznajomego" in quests or "Wróć z jedwabiem do nieznajomego" in done_quests:
        if "Dostań się do magazynu Evros" in quests:
          if timer3 == 0:
            moral_choice = input ("[1] Spróbuj się przekraść do magazynu \n[2] Zgłoś plan nieznajomego \n[3] Odejdź")
            if moral_choice == "1":
              crouching(5)
              if crouch == 1:
                print ("Przekradłem się, teraz jeszcze tylko zamek..")
                lock (8)
                if openness == 1:
                  print ("Udało mi się! Mogę przekraść się do środka")
                  time.sleep (2)
                  print ("A oto i ta słynna skrzynia..")
                  temp_chest = evros_chest
                  chests(0,0)
                  if "Jedwab" in equip:
                    quests.remove ("Dostań się do magazynu Evros")
                    quests.append ("Wróć z jedwabiem do nieznajomego")
                  else:
                    pass
                else:
                  print ("Eh, nie sforsuję tego zamka")
              else:
                print ("O mały włos.. pomyliłem się i strażnik prawie mnie odkrył")
            elif moral_choice == "2":
              print ("[STRAŻNIK] Dziękujemy z całego serca za zgłoszenie! Przypilnujemy, by ta łachudra dostała za swoje!")
              print ("A za pomoc odwdzięczymy się, rzecz jasna. Proszę, to wszystko co mogę Ci dać w ramach funduszu straży")
              print ("[dostałem 50 monet]")
              eq_money += 50
              quests.remove ("Dostań się do magazynu Evros")
              done_quests.append ("Dostań się do magazynu Evros")
              done_quests.append ("Wilczy Bilet do Gildii Złodziei")
              xp_add (10)
            else:
              pass
          else:
            print ("Jest jeszcze za wcześnie!")
        elif "Wróć z jedwabiem do nieznajomego" in quests:
          if "Jedwab" in equip:
            print ("Wiedziałem, że mogę na Ciebie liczyć! Dziękuję za jedwab.. i szczerze, przyznam Ci się do czegoś")
            print ("Jestem komendantem policji!")
            time.sleep(1)
            print ("Haha, nie. Żartowałem. Wręcz odwrotnie. Wyszukuję ludzi do innego fachu - do bycia złodziejem. Wszak tego wymaga ode mnie gildia. Słyszałeś o niej zapewne?")
            print ("Któż zresztą nie słyszał. W każdym bądź razie, spełniłeś swoje zadanie, więc i podwoja Gildii Złodziei są dla Ciebie otwarte")
            print ("Trzymaj, to moja rekomendacja Ciebie. Gildia jest dość.. nieoficjalna, i dlatego opiera się na rekomendacjach. Wypytaj o niejakiego Hrevira w Baedoor, on powie Ci, gdzie się udać")
            throw_it = "Jedwab"
            inventory (6)
            equip.append ("Rekomendacja do Gildii Złodziei")
            quests.remove ("Wróć z jedwabiem do nieznajomego")
            done_quests.append ("Wróć z jedwabiem do nieznajomego")
            quests.append ("Przystąp do Gildii Złodziei")
            xp_add (15)
          else:
            print ("Brak mi jedwabiu...")
        elif "Wróć z jedwabiem do nieznajomego" in done_quests:
          print ("Mogę się ponownie włamać do magazynu, ale straż stała się jakby czujniejsza..")
          ssdd = input ("[1] Włam się \n[2] Odejdź")
          if ssdd == "1":
            crouching(10)
            if crouch == 1:
              print ("Przekradłem się, teraz jeszcze tylko zamek..")
              lock (14)
              if openness == 1:
                print ("Jestem w środku!")
                temp_chest = evros_chest
                chests(0,0)
            else:
              print ("O mały włos.. pomyliłem się i strażnik prawie mnie odkrył")


      else:
        if "Dostań się do magazynu Evros" in done_quests:
          print ("Cóż, magazyn, nic w nim specjalnego.. ilość strażników jedynie zadziwia")
        else:
          local999 = 0
          print ("Magazyn jest zamknięty na cztery spusty, a ponadto pilnowany przez strażników.. nic tu po mnie raczej")
          local555 = input ("")
          print ("Pssst")
          print ("Zauważam człowieka, który do mnie woła, pokazując ręką, żebym do niego podszedł...")
          print ("[tajemniczy człowiek]")
          print ("Chcesz sobie dorobić? *mruga porozumiewawczo*")
          local555 = input ("[1] Zawsze chcę dorobić, dorabianie to moje całe życie \n[2] Wyrażaj się jaśniej \n[3] Nie, do widzenia \n[4] Spadaj")
          if local555 == "1":
            print ("Cudnie, w takim razie mam dla Ciebie zadanie: włam się do tego tutaj, o, magazynu. Nocą.")
            local999 = 1
          elif local555 == "2":
            print ("Otóż, miałbym dla Ciebie zadanie - włamania się do tego tu magazynu. Pasuje?")
            local556 = input ("[1] Jasne \n[2] Skądże")
            if local556 == "1":
              local999 = 1
            else:
              done_quests.append ("Dostań się do magazynu Evros")
          elif local555 == "3" or local555 == "4":
            done_quests.append ("Dostań się do magazynu Evros")
          if local999 == 1:
            print ("Za kilka godzin się ściemni, i jeżeli udasz się pod magazyn, strażnicy powinni być dość łatwi do przechytrzenia. Poza tym dostaniesz ode mnie wytrychy, i wyuczę Cię kilku fajnych technik. Przynieś mi jedwab, który jest w magazynie - tyle mi wystarczy. Co tam jest więcej, należy do Ciebie")
            wait = input("")
            lockpicking += 1
            sneaking += 1
            eq_lockpicks += 5
            quests.append ("Dostań się do magazynu Evros")
            timering(3,5)
    else:
      break

def locate_evros_city():
  global equip
  global eq_money
  print ("Miasto wygląda lepiej, niż można było tego podejrzewać - domy są zadbane i, choć nie przerażają swoją dostojnością, wydają się stać dumnie wobec wszechokalającego je morza")
  while True:
    print ("[1] Odwiedź sklep z różnościami \n[2] Odwiedź sklep zielarski \n[3] Odwiedź kowala \n[4] Wejdź do banku \n[5] Kup gazetę od chłopca gazetowego \n[6] Nic nie rób")
    local = input ("")
    if local == "1":
      print ("Dzień dobry! Czego potrzebujesz?")
      print ("[1] Kupić przedmioty \n[2] Sprzedać przedmioty \n[3] Kupić amunicję \n[4] ...nic konkretnego")
      if "Zdobądź pergamin w Evros" in quests:
        print ("[5] Przychodzę od maga z wybrzeża, prosił mnie o pergamin")
      else:
        pass
      local1 = input ("")
      if local1 == "1":
        big_buy ({"Zdobiona Strzelba":122,"Mała Mikstura Zdrowia":12,"Odtrutka":14,"Zwój Uzdrowienia":20,"Woda":9,"Papirus":6})
      elif local1 == "2":
        big_sell ({"Bandycki Rewolwer":11,"Zdobiona Strzelba":110,"Mała Mikstura Zdrowia":8,"Jedwab":100})
      elif local1 == "3":
        print ("Sprzedam Ci 10 pocisków, za 10 monet")
        local123 = input ("[1] Kupuję \n[2] Nie kupuję")
        if local123 == "1":
          big_countables (2,10,10)
        else:
          pass
      elif local1 == "5":
        if "Zdobądź pergamin w Evros" in quests:
          print ("W porządku, faktycznie, zalegam z dostawą od dłuższego czasu. Proszę, oto pergamin")
          quests.remove ("Zdobądź pergamin w Evros")
          quests.append ("Przynieś pergamin do maga")
          equip.append ("Pergamin")
        else:
          pass
      else:
        break
    elif local == "2":
      print ("Witaj! Czego potrzebujesz, kolego?")
      print ("[1] Pokaż, co masz na sprzedaż \n[2] Mogę skorzystać z laboratorium? \n[3] Odejdź")
      if "Kwiat Hyerbitusa" in equip:
        print ("[4] Mam zioła!")
      else:
        print ("[4] Potrzebujesz może ziół?")
      local45 = input ("")
      if local45 == "1":
        big_buy ({"Mała Mikstura Lecznicza":12, "Przepis na Małą Miksturę Leczniczą":25})
      elif local45 == "2":
        print ("Jasne, jest dla Twojej dyspozycji")
        herbalism_use()
      elif local45 == "4":
        if "Kwiat Hyerbitusa" in equip:
          print ("O, masz Hyerbitus, dziękuję. Oto Twoja zapłata, 10 monet")
          equip.remove ("Kwiat Hyerbitusa")
          eq_money += 10
        else:
          print ("No jasne.. na polach jest Hyerbitus. Zbierz go, a dostaniesz zapłatę")
      else:
        pass
    elif local == "3":
      print ("Witaj w moim zakładzie! \n[1] Kup przedmioty \n[2] Sprzedaj przedmioty \n[3] Mogę skorzystać z kuźni? [4] Anuluj")
      local3 = input ("")
      if local3 == "1":
        big_buy ({"Kolczuga":50, "Rapier":30, "Dynamit":27})
      elif local3 == "2":
        big_sell ({"Żelazo":10})
      elif local3 == "3":
        print ("No jasne, oto i ona")
        smithing()
      else:
        pass
    elif local == "4":
      banking()
    elif local == "5":
      print ("NAJNOWSZE WIEEŚCII!!")
      big_buy({"Gazeta Evros, 1.12.216 n.e.":2})
    else:
      break
  
def locate_evros_fields():
  global equip
  global used_equip
  global eq_money
  global sp
  global timer
  global throw_it
  global taken_item
  global weight
  print ("Przed Tobą rozpościerają się pola uprawne Evros,pełne pszenicy i ziół wszelkiego rodzaju.. wśród nich widać jednak niemało szkodników, których dziwnym trafem nikt nie tępi. Może też jest ich za dużo..")
  while True:
    print ("[1] Powalcz ze szkodnikami \n[2] Podejdź do chatki \n[3] Szukaj ziół \n[4] Skorzystaj z ogniska \n[6] Odejdź")
    if "Praca na farmie Evros" in quests:
      print ("[5] Ścinaj pszenicę")
    local = input ("")
    if local == "1":
      fight ("Szczur",1,15,5,1,1,7)
    elif local == "2":
      if "Praca na farmie Evros" in quests:
        print ("Chatka kruszy się z lekka, jednak wiesz, że możesz liczyć tu na silną dłoń farmerki")
        if "Pszenica" in equip:
          print ("[1] Mam dla pani pszenicę!")
        if "Sierp" in equip or "Sierp" in used_equip:
          print ("[2] Chciałbym rzucić pracę")
        local5 = input ("[3] Odejdź")
        if local5 == "1":
          if "Pszenica" in equip:
            print ("\nOh, cudownie, kochasiu. Dziękuję za pszenicę. Oto Twoje zasłużone pieniądze")
            equip.remove ("Pszenica")
            eq_money += 9
            print ("\nOtrzymałeś 9 sztuk złota")
          else:
            pass
        elif local5 == "2":
          if "Sierp" in equip or "Sierp" in used_equip:
            print ("Chcesz odejść? No cóż, dobrze, kochasiu. Proszę Cię, oddaj mi sierp, i uznamy naszą umowę za zakończoną")
            if "Sierp" in equip:
              throw_it = "Sierp"
              inventory(6)
            elif "Sierp" in used_equip:
              used_equip.remove ("Sierp")
              weight -= 1
            else:
              print ("Błąd?")
            quests.remove ("Praca na farmie Evros")
            done_quests.append ("Praca na farmie Evros")
          else:
            pass
        else:
          break
      else:
        print ("Podchodząc do chatki, zastajesz panią o poczciwej, pokrytej zmarszczkami twarzy. Przygląda Ci się z zainteresowaniem")
        print ("[1] Czy mogę jakoś pomóc? \n[2] Odejdź")
        local1 = input ("")
        if local1 == "1":
          print ("Jasne, że możesz pomóc, kochasiu, tu zawsze pomoc jest potrzebna. Zechcesz pracować? Będziesz dostawać wynagrodzenie za każdą sztukę pszenicy, oczywiście")
          local2 = input ("[1] Będę pracować! \n[2] Hm.. chyba sobie odpuszczę..")
          if local2 == "1":
            if "Sierp" in equip or "Sierp" in used_equip:
              pass
            else:
              print ("Cudownie, kochasiu. W takim razie weź ten sierp, i zetnij jak najwięcej pszenicy możesz")
              taken_item = "Sierp"
              inventory(5)
            quests.append ("Praca na farmie Evros")
            print ("Pszenica odrasta co jakiś czas, więc nie zetniesz zbyt wiele na jeden raz - wracaj co jakiś czas i ścinaj, a potem przynoś mi ją. Dostaniesz za każdą 9 sztuk złota")
          else:
            pass
        else:
          pass
    elif local == "3":
      if timer2 == 0:
        equip.append ("Kwiat Hyerbitusa")
        print ("Zebrałem dziwną roślinę o fioletowo-zielonej łodyżce")
        sp -= 10
        timering (2, 10)
      else:
        print ("Muszę trochę poczekać, aż zioła odrosną")
    elif local == "4":
      cooking(2)
    elif local == "5":
      if "Praca na farmie" in quests:
        if timer == 0:
          if "Sierp" in used_equip:
            equip.append ("Pszenica")
            print ("Zebrałem trochę pszenicy")
            sp -= 15
            timering (1,7)
          else:
            print ("Potrzebuję sierpu w rękach!")
        else:
          print ("Musisz poczekać jeszcze trochę, aż pszenica odrośnie")
      else:
        pass 
    else:
      break 

#------------------------leveling--------------------------
#level cech
def level_up_1():
  global strength
  global dexterity
  global intelligence
  global endurance
  global charisma
  global stats_bonus_1
  global wait
  stats_bonus_1 = input ("Wybierz, którą cechę chcesz wzmocnić \n\n[1] Siła \n[2] Zwinność \n[3] Inteligencja \n[4] Wytrzymałość \n[5] Charyzma")
  if stats_bonus_1 == "1":
    strength += 1
  elif stats_bonus_1 == "2":
    dexterity += 1
  elif stats_bonus_1 == "3":
    intelligence += 1
  elif stats_bonus_1 == "4":
    endurance += 1
  elif stats_bonus_1 == "5":
    charisma += 1
  else:
    wait = 666
#level u+
def level_up_2():
  global stats_bonus_2
  global swords
  global bows
  global guns
  global castspelling
  global connection
  global trade
  global repair
  global healing
  global lockpicking
  global sneaking
  global smithing
  global herbalism
  global vehicle_drive
  global trapspotting
  global survival
  global wait
  stats_bonus_2 = input ("Możesz ulepszyć jedną umiejętność, wybierz, którą wzmocnisz \n\n[1] Broń biała \n[2] Strzelectwo \n[3] Broń palna \n[4] Rzucanie zaklęć \n[5] Siła zjednoczenia \n[6] Handel \n[7] Naprawa \n[8] Leczenie \n[9] Otwieranie zamków \n[10] Skradanie się \n[11] Kowalstwo \n[12] Zielarstwo \n[13] Kierowanie pojazdami \n[14] Pułapki \n[15] Przeżycie")
  if stats_bonus_2 == "1":
    swords += 1
  elif stats_bonus_2 == "2":
    bows += 1
  elif stats_bonus_2 == "3":
    guns += 1
  elif stats_bonus_2 == "4":
    castspelling += 1
  elif stats_bonus_2 == "5":
    if connection >= 3:
      print ("Niestety, nie możesz podnieść tej cechy bez zwiększenia siły połączenia Twojej postaci")
      wait = 666
    else:
      connection += 1
  elif stats_bonus_2 == "6":
    trade += 1
  elif stats_bonus_2 == "7":
    repair += 1
  elif stats_bonus_2 == "8":
    healing += 1
  elif stats_bonus_2 == "9":
    lockpicking += 1
  elif stats_bonus_2 == "10":
    sneaking += 1
  elif stats_bonus_2 == "11":
    smithing += 1
  elif stats_bonus_2 == "12":
    herbalism += 1
  elif stats_bonus_2 == "13":
    vehicle_drive += 1
  elif stats_bonus_2 == "14":
    trapspotting += 1
  elif stats_bonus_2 == "15":
    survival += 1
  else:
    wait = 666

#------------------------inne-defy-------------------------
#defy itemowe
#defy inne
#defy load/save

#-----------------------creating-hero----------------------
#tworzenie postaci
while start == "createcharacter":
  print ("\n---------------------------------------------------------------")
  if tutorial_system == 1:
    print (">> Witaj w grze Between Shadows and Light! Tutorial ten będzie Cię prowadził po meandrach interfejsu - jest on pisany dość bogato w zawartość, jednak mam nadzieję, że nie spowoduje to chaosu <<")
    print (">> Pierwszym elementem gry jest stworzenie postaci, stąd za chwilę do tego przejdziemy - jest to dość istotna kwestia, jednak nie musisz się stresować, gdy nie wiesz, co dokładnie zrobić: gra stara się być tak dostosowana, by gracz z dowolnymi statystykami mógł ją względnie miło ukończyć <<")
    print (">> Istotne wspomnieć jest, że każda statystyka, umiejętność, cecha czy klasa, którą wybierzesz, będzie miała niemały wpływ na dalszy przebieg rozgrywki - wiele tych różnic jednak będziesz mógł zatrzeć w miarę gry, gdyż pierwsze wybory są na równi znaczące, jak i dalej: styl gry i wybory w niej dokonywane <<")
  else:
    pass
  time.sleep(1)
  #1 imię
  name = input ("\nJak ma się nazywać Twój bohater?")
  #2 płeć
  time.sleep(1)
  gender = input ("\nJakiej ma być płci? \n[1] Mężczyzna \n[2] Kobieta")
  #3 rasa
  print ("\n--------------------------")
  time.sleep(1)
  race = input ("\nJaką rasę reprezentujesz? \n\n[1] Człowiek \nNajbardziej rozpowszechniona rasa w świecie Baedoor \n\n[2] Nord \nNordzi są ludźmi, jednak zahartowanymi życiem w mroźnych północnych krainach \n\n[3] Ett \nCi mieszkańcy gór są świetnymi mechanikami i są obyci w technologii \n\n[4] Saphtri \nCi elfowie są wyjątkowo zwinni, dzięki swojemu życiu na drzewach, jednak nie wyrobili sobie oni naturalnej odporności \n\n[5] Czarne Elfy \nW odróżnieniu od saphtri, ci elfowie bardziej cenią sobie dostojne życie, a ich oczytanie rozwinęło znacznie ich intelekt \n\n[6] Ormathowie \nTajemnicza rasa szaroskórych niziołków, którzy opanowali moce natury, dające im przewagę mimo dość lichego ciała")
  #4 klasa
  print ("\n--------------------------")
  time.sleep(1)
  craft = input ("\nJaką klasę wybierasz? \n\n[1] Bezklasowiec \nBezklasowiec nie ma żadnych modyfikatorów, jednak nie jest w stanie używać co bardziej zaawansowanej broni planej czy czarów \n\n[2] Wojownik \n Wojownik poświęcił się walce tradycyjną bronią, i to jest jego prawdziwe powołanie \n\n[3] Strzelec \nStrzelec jest klasą technologiczną, posiada również dostęp do najbardziej zaawansowanej broni palnej \n\n[4] Mag \nMag jest klasą magiczną, dzięki czemu może używać najsilniejszych czarów \n\n[5] Handlarz \nHandlarz niezbyt dobrze radzi sobie w walce, ale jego powołaniem jest handel! \n\n[6] Skrytobójca \nSkryty w cieniu, jego przeznaczeniem jest podstęp i sprytne użycie swojej niewidzialności \n\n[7] Mechanik \nMechanik cały swój czas spędził w warsztacie, próbując tworzyć broń i narzędzia najróżniejszego rodzaju \n\n[8] Outlander \nTo odszczepieniec, człowiek przyzwyczajony do życia w dzikich ostępach przyrody, samotnik \n\n[9] Nekromanta \nPraktykant zakazanej sztuki wskrzeszania umarłych \n\n[10] Uzdrowiciel \nZnachorzy są cenieni w świecie za swe ponadprzeciętne lecznicze umiejętności \n\n[11] Kapłan ormacki \nPolecana głównie ormathom, wzmacnia ona głównie siłę zjednoczenia, tak potrzebną tej rasie")
  #5 bonus staty
  print ("\n--------------------------")
  level_up_1()
  time.sleep(1)
  print ("\n--------------------------")
  level_up_2()
  time.sleep(1)
  #6 calculating
  if gender == "1":
    endurance -= 1
    gender = "Mężczyzna"
  elif gender == "2":
    strength -= 1
    gender = "Kobieta"
  else:
    continue

  if race == "1":
    race = "Człowiek"
  elif race == "2":
    strength += 1
    dexterity -= 2
    endurance += 2
    race = "Nord"
  elif race == "3":
    strength += 1
    dexterity -= 2
    intelligence += 1
    endurance += 1
    pwr_tech += 5
    pwr_magic -= 5
    race = "Ett"
  elif race == "4":
    strength -= 1
    dexterity += 2
    intelligence += 1
    endurance -= 1
    race = "Saphtri"
  elif race == "5":
    strength -= 1
    dexterity += 1
    intelligence += 2
    endurance -= 1
    pwr_magic += 5
    pwr_tech -= 5
    race = "Czarne Elfy"
  elif race == "6":
    strength -= 2
    dexterity += 1
    endurance += 1
    pwr_conn += 10
    connection += 1
    race = "Ormath"
  else:
    continue

  if craft == "1":
    charisma += 1
    craft = "Bezklasowiec"
  elif craft == "2":
    swords += 1
    bows += 1
    guns -= 1
    intelligence -= 1
    craft = "Wojownik"
  elif craft == "3":
    pwr_tech += 5
    pwr_magic -= 5
    guns += 2
    castspelling = 0
    repair += 1
    craft = "Strzelec"
  elif craft == "4":
    pwr_magic += 5
    pwr_tech -= 5
    castspelling += 2
    guns = 0
    healing += 1
    craft = "Mag"
  elif craft == "5":
    strength -= 1
    charisma += 1
    trade = 3
    craft = "Handlarz"
  elif craft == "6":
    dexterity += 2
    strength -= 1
    sneaking += 1
    lockpicking = 1
    craft = "Skrytobójca"
  elif craft == "7":
    pwr_tech += 15
    pwr_magic -= 15
    repair += 2
    smithing += 1
    vehicle_drive += 1
    craft = "Mechanik"
  elif craft == "8":
    charisma -= 2
    repair += 1
    survival += 1
    trapspotting += 1
    healing += 1
    craft = "Outlander"
  elif craft == "9":
    pwr_chaos += 8
    pwr_conn = -20
    pwr_tech -= 5
    pwr_magic += 5
    castspelling = 2
    guns = 0
    craft = "Nekromanta"
  elif craft == "10":
    pwr_magic += 5
    pwr_tech -= 5
    strength -= 1
    guns -= 1
    healing += 2
    herbalism += 2
    craft = "Uzdrowiciel"
  elif craft == "11":
    pwr_conn += 5
    pwr_chaos -= 10
    connection += 2
    herbalism += 1
    guns -= 1
    craft = "Kapłan ormacki"
  else:
    continue

  if wait == 666:
    continue
  else:
    pass

  #showing the card
  print ("\n--------------------------")
  menu_postac ()
  x = input ("\nWciśnij Enter, gdy będziesz gotowy")
  start = 1
  mainquest = 1
  break

#loading
if load == 1:
  loading ()
else:
  pass
    
def basic_hpmp():
  global hp_level
  global mp_level
  global endurance
  global intelligence
  global pwr_magic
  hp_level = 20 + endurance*10
  if hp_level < 100:
    hp_level = 100
  else:
    pass
  mp_level = 20 + intelligence*10 + pwr_magic*10
  if mp_level < 0:
    mp_level = 0
  else:
    pass

#--------------------quest startowy------------------------
#main quest
if mainquest == 1:
  if load == 0:
    location = "Statek 'Arennan'"
    m_quest1 ()


#--------------------------gra-----------------------------
#właściwa gra
while start == 1:
  #ekran
  if eq_maxarmor > 0:
    armor_hp = int(eq_armor/eq_maxarmor*100)
  else:
    armor_hp = 0
  if settings_system == 2:
    print("\n---------------------------------------------------------------")
    menu_image()
  else:
    pass
  print ("---------------------------------------------------------------")
  time.sleep (1)
  #ekran powiadomień
  if load == 1:
    if settings_system == 2:
      print ("\x1b[1;32;42m" + "Załadowano grę!" + "\x1b[0m")
    else:
      print ("[" + "Załadowano grę!" + "]")
    load = 0
  else:
    pass
  if sp < 100:
    if settings_system == 2:
      print ("\x1b[1;37;41m" + "Jesteś zmęczony!" + "\x1b[0m")
    else:
      print ("[" + "Jesteś zmęczony!" + "]")
  else:
    pass
  if sp < 10:
    hp -= 2
  elif sp <= 0:
    hp -= 8
  else:
    pass
  if weight > max_weight:
    if settings_system == 2:
      print ("\x1b[1;37;41m" + "Jesteś przeciążony!" + "\x1b[0m")
    else:
      print ("[" + "Jesteś przeciążony!" + "]")
    sp -= 50
  else:
    pass
  if eq_poisoning > 0:
    if settings_system == 2:
      print ("\x1b[1;37;41m" + "Jesteś zatruty!" + "\x1b[0m")
    else:
      print ("[" + "Jesteś zatruty!" + "]")
    hp -= 3
  else:
    pass
  #śmierć
  if hp <= 0:
    print ("Niestety, zginąłeś!")
    break
  else:
    pass
  #level up
  if xp >= xp_level:
    temp_xp = xp - xp_level
    if temp_xp > 0:
      xp = temp_xp
    else:
      temp_xp = 0
    if settings_system == 2:
      print ("\x1b[6;30;42m" + "Nowy poziom!" + "\x1b[0m")
    else:
      print ("[" + "Nowy poziom!" + "]")
    print ("\n--------------------------")
    basic_hpmp()
    hp = hp_level
    sp = 1000
    mp = mp_level
    level += 1
    level_up_1()
    print ("\n--------------------------")
    level_up_2()
    print ("\n--------------------------")
    xp_level = level*12
    if xp_level < 100:
      xp_level = 100
    else:
      pass
  else:
    pass
  #bank
  if eq_bank > 0:
    temp_bank = eq_bank/100
    temp_bank = temp_bank*3
    eq_bank = eq_bank + temp_bank
  else:
    pass
  #timer
  if timer == 1 or timer2 == 1 or timer3 == 1:
    if timer == 1:
      timer_time -= 1
      if timer_time <= 0:
        timer = 0
      else:
        pass
    else:
      pass
    if timer2 == 1:
      timer_time2 -= 1
      if timer_time2 <= 0:
        timer2 = 0
      else:
        pass
    else:
      pass
    if timer3 == 1:
      timer_time3 -= 1
      if timer_time3 <= 0:
        timer3 = 0
      else:
        pass
    else:
      pass
  else:
    pass

  #statystyki
  sp -= 1
  max_weight = strength*3
  basic_hpmp()#hp/mp level ustawiany

  #true ekran
  time.sleep (1)
  print ("\n[",location,"]")
  print ("\nHP", hp)
  print ("Poziom", level)
  print ("Ciężar", weight, "/", max_weight)
  print ("\n[POSTAC] [EKWIPUNEK] [LOKACJA] [MAPA] [DZIENNIK]")

  #wybory menu
  choice = input ("")
  choice = choice.upper()

  
  while choice == "POSTAC":
    print ("\n--------------------------")
    menu_postac()
    wait = input ("")
    break
  
  while choice == "EKWIPUNEK":
    print ("\n--------------------------")
    equip_choose()
    break
  
  while choice == "LOKACJA":
    print ("\n--------------------------")
    if location == "Statek 'Arennan'":
      locate_ship_arennan()
      break
    elif location == "Wybrzeże Evros":
      locate_evros_port()
      break
    elif location == "Evros":
      locate_evros_city()
      break
    elif location == "Pola Evros":
      locate_evros_fields()
      break
    elif location == "Bezludna Wyspa":
      locate_shelter_island()
      break
    elif location == "Dom na Bezludnej Wyspie":
      locate_shelter_home()
      break
    else:
      print ("Błąd lokacji!")
      break
  
  while choice == "MAPA":
    print ("\n--------------------------")
    menu_mapa()
    menu_journey()
    break
  
  while choice == "DZIENNIK":
    print ("\n--------------------------")
    menu_dziennik()
    if wait == 666:
      continue
    else:
      break

  while choice == "CHEAT":
    encyclopaedia()
    local = input ("")
    locationbook()
    local = input ("")
    spellbook()
    local = input ("")
    herbalistbook()
    local = input ("")
    smithbook()
    local = input ("")
    break


  #-------------ostatnie-stany-i-ograniczniki---------------
  if pwr_magic > 20:
    pwr_magic = 20
  elif pwr_tech > 20:
    pwr_tech = 20
  elif pwr_chaos > 20:
    pwr_chaos = 20
  elif pwr_conn > 20:
    pwr_conn = 20
  else:
    pass

  #ewentualne naddatki życia/many
  if hp > hp_level:
    hp = hp_level
  else:
    pass
  if mp > mp_level:
    mp = mp_level
  else:
    pass

  basic_armor()

  if quit == 1 or start == "death":
    break
  else:
    pass

#------------------questy i mainquest----------------------
  if mainquest == 1 and sp < 992 and location == "Statek 'Arennan'" and equip != False:
    mainquest = 2
    m_quest2()






#29.7.18