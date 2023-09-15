#ekran startowy
import time
import random
load = 0
start = 0

while True:
  start_ = input ("----------------------- \n[Enter] Rozpoczyna grę \n[L] Ładuje grę \n[P] Ładuje poradnik \n[Q] Kończy grę")
  start_ = start_.upper ()
  if start_ == "":
    start = 1
    break
  
  elif start_ == "L":
    try:
      loaded_file = open ("bslsave.py","r")
      loaded_file2 = open ("bsl2save.py","r")
      load = 1
      break
    except FileNotFoundError:
      print ("Nie znaleziono plików zapisu")
      time.sleep (3)
      continue
    
  elif start_ == "P":
    print ("\nWprowadź numer zagadnienia, które Cię interesuje: \n[1] Ogólna rozgrywka \n[2] Cechy i poziom postaci \n[3] Świat i poruszanie się \n[4] Zadania \n[5] Walka")
    introduction = input (":")
    if introduction == "1":
      print ("\n[OGÓLNA ROZGRYWKA] \nGra Between Shadows and Light jest typową tekstową grą RPG, której istotą jest kierowanie bohaterem, wykonywanie zadań, awansowanie go na wyższe poziomy i pokonywanie wrogów, odkrywanie świata i podążanie za fabułą. Jej struktura jest jednak dość otwarta, naśladująca sandboxowy tryb z gry Fallout - więcej o tym w części o świecie i poruszaniu się - zatem BS&L jest grą skupioną głównie na odkrywaniu świata, a dopiero na drugim miejscu na fabule")
      time.sleep (5)
      continue
    elif introduction == "2":
      print ("\n[POSTAĆ] \nPoziom postaci na początku jest niski, a cechy zależą od Twojego wyboru z puli 10 punktów, jak i wyboru rasy: te cechy jednak zmienią się wraz z awansowaniem na kolejne poziomy. Poziom Twojego bohatera jest zaś związany z doświadczeniem, zdobywanym przez różnorakie czynności - od wykonywania zadań, rozmów, po walkę i odkrywanie")
      time.sleep (4)
      continue
    elif introduction == "3":
      print ("\n[MAPA I PODRÓŻ] \nPoruszanie się po świecie przypomina system z gier Fallout, czyniąc grę dość otwartą - otóż, mapa dzieli się na dwie kategorie, rejonów i podrejonów. Między rejonami poruszasz się w dowolny sposób, jednak ponosząc pewne ryzyko napotkania losowego zdarzenia, bądź odkrycia lokacji. Z kolei podrejony są częściami rejony, do którego wszedłeś: między nimi poruszasz się przez wskazywanie, w którą stronę chcesz pójść - wyjście z podrejonu do rejonu dostępne jest jedynie przy zbliżeniu się do odpowiednich miejsc w podrejonie")
      time.sleep (5)
      continue
    elif introduction == "4":
      print ("\n[ZADANIA] \nZadania oferowane są przez różne osoby i mają różny charakter - od rozmowy, zrobienie czegoś, po walkę. Zwykle wiążą się z jakimś wysiłkiem, jednak nagradzane są doświadczeniem, pieniędzmi, czasami przedmiotami")
      time.sleep (3)
      continue
    elif introduction == "5":
      print ("\n[WALKA] \nWalka jest oddzielnym trybem gry, w którym zmierzasz się z przeciwnikiem, testując siłę swojej postaci, jak i broni oraz pancerza")
      time.sleep (3)
      continue
    else:
      print ("Pomyliłeś coś, wracamy do menu")
      continue
    
  elif start_ == "Q":
    start = 0
    break
  else:
    continue

#statystyki i podstawowe informacje o graczu w bazie danych
hp = 100
magicpoints = 0
location = ("")
map_speed = 0
equip = []
equip_weight = 0
max_weight = 15
attack = 0
armor = 0
level = 1
experience = 0

#wybierane przez gracza
name = ("")
race = 0

#skille
strength = 0
agility = 0
charisma = 0
manaskill = 0
connectskill = 0

#tworzenie postaci
while start == 1:
  print ("---------------------Between Shadows and Light---------------------")
  name = input ("Proszę wpisać imię postaci")
  
  #cheat na ominięcie wpisywania, w celu szybszego testu
  if name == "Heresur":
    strength = 666
    agility = 666
    charisma = 666
    manaskill = 666
    connectskill = 666
    level = 666
    race = "Bóg-Niszczyciel"
    equip.append ("Miecz Zniszczenia")
    equip.append ("Zwój Ognistego Deszczu")
    equip.append ("Zwój Nieśmiertelnego Tchnienia")
    start = 2
    continue
  else:
    pass
  
  race = input("\n\nProszę wybrać klasę z podanych: \nCzłowiek - nieco bardziej charyzmatyczny mieszkaniec głównej wyspy \nKrasnolud - nabył odporność, mieszkając w górach wyspy Rossevette \nElf - delikatny mieszkaniec południa, jednak nadzwyczaj zwinny \nOrmath - dziwny lud, dobrze obyty jednak z siłą zjednoczenia")
  race = race.capitalize ()
  if race == "Człowiek":
    charisma += 1
  elif race == "Elf":
    strength -= 2
    agility += 2
  elif race == "Krasnolud":
    strength += 3
    agility -= 2
    charisma -= 1
  elif race == "Ormath":
    charisma -= 1
    connectskill += 3
  else:
    print ("Podałeś błędnie rasę!")
    continue
  
  print ("\n\nWybierz teraz cechy, którym rozdysponujesz punkty - nie przekrocz jednak 10 punktów, które posiadasz, ani nie podawaj 0!")
  print ("Cechy: \nSiła \nZręczność \nCharyzma \nMagia \nSiła połączenia\n")
  skill_points = 10
  print ("Punkty cech:", skill_points)
  strength_add = input ("Ile punktów siły chcesz dodać?")
  strength_add = int(strength_add)
  if strength_add > skill_points:
    print ("Podałeś za dużo punktów!")
    continue
  else:
    strength += strength_add
    skill_points -= strength_add
    
  print ("Punkty cech:", skill_points)
  agility_add = input ("Ile punktów zręczności chcesz dodać?")
  agility_add = int(agility_add)
  if agility_add > skill_points:
    print ("Podałeś za dużo punktów!")
    continue
  else:
    agility += agility_add
    skill_points -= agility_add

  print ("Punkty cech:", skill_points)
  charisma_add = input ("Ile punktów charyzmy chcesz dodać?")
  charisma_add = int(charisma_add)
  if charisma_add > skill_points:
    print ("Podałeś za dużo punktów!")
    continue
  else:
    charisma += charisma_add
    skill_points -= charisma_add
    
  print ("Punkty cech:", skill_points)
  manaskill_add = input ("Ile punktów magii chcesz dodać?")
  manaskill_add = int(manaskill_add)
  if manaskill_add > skill_points:
    print ("Podałeś za dużo punktów!")
    continue
  else:
    manaskill += manaskill_add
    skill_points -= manaskill_add    
    
  print ("Punkty cech:", skill_points)
  connectskill_add = input ("Ile punktów siły połączenia chcesz dodać?")
  connectskill_add = int(connectskill_add)
  if connectskill_add > skill_points:
    print ("Podałeś za dużo punktów!")
    continue
  else:
    connectskill += connectskill_add
    skill_points -= connectskill_add  
    
  #usuwanie ewentualnych ujemnych wartości
  if strength < 0:
    strength = 0
  elif agility < 0:
    agility = 0
  elif charisma < 0:
    charisma = 0
  elif manaskill < 0:
    manaskill = 0
  elif connectskill < 0:
    connectskill = 0
  else:
    pass

  #ostatni panel kreowania, skrótowe objaśnienie postaci
  print ("\n\n\nTwoja karta postaci: \nImię:", name, "\nRasa:", race, "\nPoziom", level, "\n\nCechy: \nSiła", strength, "\nZręczność", agility, "\nCharyzma", charisma, "\nMagia", manaskill, "\nSiła połączenia", connectskill)
  waiting_point = input ("Naciśnij enter, by przenieść się do świata!")
  start = 2
  

#...

#przedmioty - klasa
class Items:
  def __init__ (self, name, weight):
    self.name = name
    self.weight = weight
    
class Weapons:
  definition = ("Bronie")
  def __init__ (self, name, weight, damage):
    self.name = name
    self.weight = weight
    self.damage = damage
    
class Armors:
  definition = ("Pancerze")
  def __init__ (self, name, weight, defence):
    self.name = name
    self.weight = weight
    self.defence = defence
      
class Scrolls:
  definition = ("Zwoje")
  #...
      
class Ingredients:
  definition = ("Zioła")
  #...

#...

#przedmioty - lista

#...











#lokacje - klasa

class Locations:
  def __init__ (self, name, id):
    self.name = name

#lokacje - lista

#...


#loading
if load == 1:
  loadfile = open ("bslsave.py","r")
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
  loadfile.close()
  name = ''.join(line1)
  level = ''.join(line2)
  experience = ''.join(line3)
  race = ''.join(line4)
  location = ''.join(line5)
  hp = ''.join(line6)
  magicpoints = ''.join(line7)
  equip_weight = ''.join(line8)
  attack = ''.join(line9)
  armor = ''.join(line10)
  strength = ''.join(line11)
  agility = ''.join(line12)
  charisma = ''.join(line13)
  manaskill = ''.join(line14)
  connectskill = ''.join(line15)
  start = ''.join(line16)
  level = int(level)
  experience = int(experience)
  hp = int(hp)
  magicpoints = int(magicpoints)
  equip_weight = int(equip_weight)
  attack = int(attack)
  armor = int(armor)
  strength = int(strength)
  agility = int(agility)
  charisma = int(charisma)
  manaskill = int(manaskill)
  connectskill = int(connectskill)
  start = int(start)
  if name.endswith("\n"):
    name = name[:-1]
  else:
    pass
  if race.endswith("\n"):
    race = race[:-1]
  else:
    pass
  if location.endswith("\n"):
    location = location[:-1]
  else:
    pass
  loadfile2 = open ("bsl2save.py","r")
  for item in loadfile2:
    if item.endswith("\n"):
      item = item[:-1]
    equip.append (item)
else:
  pass

#wrzucenie gracza w grę po raz pierwszy (nieaktywne przy loadingu)
if start == 2:
  location = ("Doki Baedoor")
  start = 3
else:
  pass

#właściwa rozgrywka
while start == 3:
  #update_statystyk zależnych od cech:
  max_weight = strength * 5
  if max_weight < 15:
    max_weight = 15
  else:
    pass
  map_speed = agility * 1
  if map_speed < 1:
    map_speed = 1
  else:
    pass
  
  #panel gry:
  print ("\n\n---------------------------------------------")
  print ("["+location+"]")
  print ("HP", hp)
  print ("Poziom", level)
  print ("Ciężar", equip_weight, "/", max_weight)
  print ("\n[POSTAC] [EKWIPUNEK] [LOKACJA] [MAPA] [MENU]")
  choice = input (":")
  choice = choice.upper()
  choice_check = 0

  while choice == "POSTAC":
    print ("\nPostać:")
    print ("----------------------")
    print (name, "\nPoziom", level, "\nXP", experience, "\n\nSiła", strength, "\nZręczność", agility, "\nCharyzma", charisma, "\nMagia", manaskill, "\nSiła zjednoczenia", connectskill, "\n\nPrędkość poruszania się po mapie", map_speed, "Limit ciężaru", max_weight)
    print ("----------------------")
    time.sleep (3)
    break

  while choice == "EKWIPUNEK":
    choice_check = 2
    print ("\nEkwipunek:")
    print (equip)
    time.sleep (2)
    break
  
  while choice == "LOKACJA":
    choice_check = 3
    print ("\nLokacja:", location)
    print ("Opcje do wyboru:")
    location_choose = input (":")
    continue
  
  while choice == "MAPA":
    choice_check = 4
    print ("\nMapa:")
    continue
  
  while choice == "MENU":
    choice_check = 5
    print ("\nMenu:")
    print ("[1] Zapis gry \n[2] Wyjście z gry \n[3] Powrót do gry")
    menu_choose = input (":")
    if menu_choose == "1":
      savefile = open ("bslsave.py","w")
      savefile2 = open ("bsl2save.py","w")
      #zmiana typów int->str, błąd pythona w innym przypadku
      level = str(level)
      experience = str(experience)
      hp = str(hp)
      magicpoints = str(magicpoints)
      equip_weight = str(equip_weight)
      attack = str(attack)
      armor = str(armor)
      strength = str(strength)
      agility = str(agility)
      charisma = str(charisma)
      manaskill = str(manaskill)
      connectskill = str(connectskill)
      start = str(start)
      saved_text = (name + "\n" + level + "\n" + experience + "\n" + race + "\n" + location + "\n" + hp + "\n" + magicpoints + "\n" + equip_weight + "\n" + attack + "\n" + armor + "\n" + strength + "\n" + agility + "\n" + charisma + "\n" + manaskill + "\n" + connectskill + "\n" + start)
      savefile.write (saved_text)
      for item in equip:
        savefile2.write("%s\n" % item)
      savefile.close ()
      savefile2.close ()
      print ("Gra została zapisana!")
      #na wszelki wypadek wracam str->int (gdyby save był tylko nerwowy i nie świadczył o końcu gry)
      level = int(level)
      experience = int(experience)
      hp = int(hp)
      magicpoints = int(magicpoints)
      equip_weight = int(equip_weight)
      attack = int(attack)
      armor = int(armor)
      strength = int(strength)
      agility = int(agility)
      charisma = int(charisma)
      manaskill = int(manaskill)
      connectskill = int(connectskill)
      start = int(start)
      time.sleep (2)
      continue
    elif menu_choose == "2":
      start = 0
      break
    elif menu_choose == "3":
      break
    else:
      continue

  if choice_check == 0:
    continue
#tutaj prawdopodobnie będzie mogła iść dalej fabuła, tzn. będzie oddawała 'continue', ale może zwracać kolejne fabularne zmienne, zależnie od decyzji itp.
  else:
    continue







































#----------------

#TODO
# - ekran startowy
# - samouczek
# - load/save (2 miejsca)
#
# - staty, ekwipunek, przedmioty:
#   - zioła
#   - zwoje
#
# - lokacje
#
# - rozgrywka:
#   - ekwipunek
#   - podróż/mapa
#   - lokacja

# "Krasnoludy" -> właściwa nazwa?




#--------------------------------------------------------
#data rozpoczęcia: 19-3-2018

#objaśnienie zmiennych:

#start - zmienna włączająca grę, ale również zależna od jej postępów
#        1: wpisywanie statystyk
#        2: "wrzucenie" gracza do gry, wybór lokacji i reszty           rzeczy
#        3: gra właściwa, rozpoczęcie

#waiting_point - zmienna używana ilekroć potrzeba grę zatrzymać na moment, by enter potwierdził jej ciąg dalszy



#--------------------------------------------------------
#"Between Shadows and Light"
#Autor: Tomasz Stępień
#Wersja: v.0.1