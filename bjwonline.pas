unit BJWOnline;

{$H+}{$CODEPAGE CP866}
{$codepage UTF8}
{$MODE OBJFPC}

interface

uses
  CRT, Classes, SysUtils;

const
  Loading = '. . .';
  MAXPLAYERS = 2;
  MAXBOTS = 7;
  MAXACCOUNTS = 2;
  MAXPLAYERCARDS = 8;
  MAXCARDDECK = 52;
  COLORBACKGROUND = Green;
  TEXTCOLORS = white;


type
  TPlayer = record
    Cards: array [1..MAXPLAYERCARDS] of word;           //Массив карт
    FirstMove: 0..2;                                    //Первыйх ход
    SumValuesCard: word;                                //Сумма всех карт
    NumberCard: 0..MAXPLAYERCARDS;                      //Количество карт
    Cash: integer;                                      //Бабло
    Bet: integer;                                       //Ставка игрока
    NamePlayer: string;                                 //Имя игрока
    PasswordPlayer: string;                             //Пароль игрока
    NumberPlayerInArray: word;                          //Порядковый номер игрока в файле
  end;


procedure LaunchingProgramOnline;

var
  Winner: string[100];
  MenuSelection, LoginSelection, NewGameSelection, NewGameBoolean,
  WinSelection, HideSelection, MakeBetSwitch, LogOutSwitch, ExitOnline,
  AdminSwitch, SwapSwitch: boolean;
  Player: array [1..MAXACCOUNTS] of TPlayer;
  CardDeck: array[1..13, 1..4] of integer;
  WhatPlayersInGame: array[1..MAXBOTS] of word;
  ForbiddenCard: array[1..MAXCARDDECK] of string;
  NumberAccounts, PositionFirstAccountInArray, PositionSecondAccountInArray,
  FirstPlayerNumber, QuantityCards, QuantityPlayerInPlay, ForbiddenCardNumber,
  Bank: integer;
  T: Text;

implementation

procedure LoginAccountForFirstPlayer; forward;
procedure LoginAccountForSecondPlayer; forward;
procedure MenuGame; forward;
procedure StartGame; forward;
procedure NewGameForFirst; forward;

procedure BJLabel;
begin
  TextBackground(COLORBACKGROUND);
  TextColor(TEXTCOLORS);
  clrscr;
  gotoxy(1, 1);
  Writeln(
    '========================================================================================================================');
  gotoxy(13, 2);
  Writeln(' .______    __          ___       ______  __  ___        __       ___       ______  __  ___ MULTIPLAYER ');
  gotoxy(13, 3);
  Writeln(' |   _  \  |  |        /   \     /      ||  |/  /       |  |     /   \     /      ||  |/  / ');
  gotoxy(13, 4);
  Writeln(' |  |_)  | |  |       /  ^  \   |  ,----.|  .  /        |  |    /  ^  \   |  ,----.|  .  /  ');
  gotoxy(13, 5);
  Writeln(' |   _  <  |  |      /  /_\  \  |  |     |    <   .--.  |  |   /  /_\  \  |  |     |    <   ');
  gotoxy(13, 6);
  Writeln(' |  |_)  | |  `----./  _____  \ |  `----.|  .  \  |  `--.  |  /  _____  \ |  `----.|  .  \  ');
  gotoxy(13, 7);
  Writeln(' |______/  |_______/__/     \__\ \______||__|\__\  \______/  /__/     \__\ \______||__|\__\ ');
  gotoxy(1, 8);
  Writeln(
    '========================================================================================================================');
end;

procedure Whore;
begin
  TextBackground(Black);
  TextColor(TEXTCOLORS);
  Writeln('___________________________¶¶¶¶¶¶¶¶');
  Writeln('_______¶¶¶¶¶¶¶¶¶_________¶¶¶¶¶¶¶¶¶¶¶');
  Writeln('______¶¶_______¶¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶');
  Writeln('_____¶¶______¶¶_¶¶______¶¶¶¶¶¶¶¶¶¶¶¶¶');
  Writeln('_____¶_____¶¶¶¶¶¶¶______¶¶_¶¶¶¶¶¶¶¶¶¶');
  Writeln('_____¶____¶¶¶____¶______¶___¶¶¶¶¶¶¶¶¶');
  Writeln('_____¶¶___¶¶¶__¶¶¶¶____¶¶____¶¶¶¶¶¶¶');
  Writeln('_____¶¶___¶¶¶¶_¶¶¶______¶¶¶_¶¶¶¶¶¶¶');
  Writeln('____¶¶¶¶___¶_¶¶¶¶________¶¶¶¶¶____¶¶¶');
  Writeln('____¶¶¶¶¶__¶¶¶¶¶¶____________¶¶¶___¶¶¶');
  Writeln('___¶¶¶¶¶¶¶¶_¶_¶¶¶¶___________¶¶______¶¶');
  Writeln('__¶¶______¶_¶¶¶¶_¶__________¶¶_______¶¶¶');
  Writeln('__¶_______¶¶¶¶¶¶¶¶¶_________¶_________¶¶');
  Writeln('__¶_____¶¶__¶¶¶_¶¶¶________¶¶__________¶');
  Writeln('__¶______¶¶__¶¶_¶¶¶¶______¶¶___________¶');
  Writeln('__¶¶¶¶____¶¶__¶¶_¶¶¶¶___¶¶¶____¶¶¶____¶¶');
  Writeln('___¶_¶¶____¶¶¶¶¶_¶¶_¶__¶¶______¶______¶¶');
  Writeln('___¶__¶¶___¶¶¶¶¶¶¶__¶¶¶¶_____¶¶______¶¶');
  Writeln('___¶___¶¶____¶¶_¶¶¶__¶¶_____¶¶______¶¶');
  Writeln('___¶____¶¶¶___¶¶¶¶¶¶¶¶____¶¶¶_______¶');
  Writeln('___¶______¶¶¶¶¶¶¶¶¶¶___¶¶¶¶________¶¶');
  Writeln('___¶________¶¶____¶¶__¶¶¶¶_________¶');
  Writeln('__¶¶_____¶¶¶_______¶¶¶¶¶¶¶________¶¶');
  Writeln('__¶¶___¶¶¶__________¶¶¶¶¶¶________¶¶¶');
  Writeln('_¶¶__¶¶¶_______¶_____¶¶¶¶_________¶¶¶¶');
  Writeln('¶¶_¶¶¶________¶¶¶_____¶¶___________¶_¶¶');
  Writeln('¶¶____________¶_¶______¶___________¶¶_¶¶');
  Writeln('¶¶___________¶¶¶¶¶¶____¶¶__________¶¶__¶¶¶¶');
  Writeln('_¶¶_________¶¶¶¶¶¶¶¶____¶¶_______¶¶¶¶¶¶¶¶_¶¶¶¶¶¶¶¶');
  Writeln('_¶¶¶______¶¶¶¶_____¶¶____¶¶¶¶¶¶¶¶¶¶¶¶__¶__¶¶¶¶¶¶¶¶');
  Writeln('___¶¶¶¶¶¶¶¶___¶¶¶¶¶¶¶¶¶___¶¶¶_____¶¶¶¶_¶¶¶¶¶¶¶¶');
  Writeln('_____¶¶¶¶¶__¶¶¶_______¶¶¶___¶¶¶¶¶___¶¶¶¶¶¶¶');
  Writeln('________¶¶______________¶____¶¶_¶¶¶____¶¶¶¶¶');
  Writeln('_________¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶____¶¶¶¶¶¶¶¶¶¶¶¶¶');
  Writeln('__________________________¶¶_____¶¶¶¶');
  Writeln('__________________________¶¶¶¶______¶¶¶¶');
  Writeln('_____________________________¶¶¶¶¶¶¶¶¶¶¶');
end;

procedure LoadingLaod;
var
  Counter: integer;
begin
  for Counter := 1 to length(Loading) do
  begin
    Delay(100);
    Write(Loading[Counter]);
    Delay(100);
  end;
end;

procedure LoadingWindow;//Home screen setup
var
  Counter: integer;
  Start: string;
begin
  BJLabel;
  gotoxy(47, 10);
  Write('Loading BlackJack ');
  for Counter := 1 to length(Loading) do
  begin
    Delay(200);
    Write(Loading[Counter]);
    Delay(200);
  end;
  gotoxy(49, 12);
  Writeln('Enter to start');
  gotoxy(63, 12);
  Readln(Start);
end;

procedure ClearScreen;//Clear Screen
begin
  ClrScr;
end;


function NumberSimbolsInString(YouString: string; Simbol: string): integer;
var
  Counter: integer;
begin
  NumberSimbolsInString := 0;
  for Counter := 1 to length(YouString) do
    if YouString[Counter] = Simbol then
      Inc(NumberSimbolsInString);
end;

function CheckIntroducedSTR(Introduced: string): boolean;
var
  Code, Symbol: integer;
begin
  Code := 0;
  Val(Introduced, Symbol, Code);
  if Code <> 0 then
    CheckIntroducedSTR := True
  else
    CheckIntroducedSTR := False;
end;

procedure SumValueCards;
var
  CounterNumberCard: integer;
begin
  Player[PositionSecondAccountInArray].SumValuesCard := 0;

  for CounterNumberCard := 1 to Player[PositionSecondAccountInArray].NumberCard do
  begin
    Player[PositionSecondAccountInArray].SumValuesCard :=
      Player[PositionSecondAccountInArray].SumValuesCard +
      Player[PositionSecondAccountInArray].Cards[CounterNumberCard];
  end;

  Player[PositionFirstAccountInArray].SumValuesCard := 0;

  for CounterNumberCard := 1 to Player[PositionFirstAccountInArray].NumberCard do
  begin
    Player[PositionFirstAccountInArray].SumValuesCard :=
      Player[PositionFirstAccountInArray].SumValuesCard +
      Player[PositionFirstAccountInArray].Cards[CounterNumberCard];
  end;
end;

procedure RecountDeck;
var
  TotalNumberCards: integer;
begin
  SumValueCards;
  TotalNumberCards := 0;
  QuantityCards := 0;

  TotalNumberCards += Player[PositionFirstAccountInArray].NumberCard;
  TotalNumberCards += Player[PositionSecondAccountInArray].NumberCard;

  QuantityCards := MAXCARDDECK - TotalNumberCards;
end;

procedure AddForbiddenCard(Comb: string);//AddForbiddenCard
begin
  Inc(ForbiddenCardNumber);
  ForbiddenCard[ForbiddenCardNumber] := Comb;
end;

function CombinationCheck(Comb: string): boolean;//combination check
var
  i, Check: integer;
begin
  Check := 0;
  for i := 1 to ForbiddenCardNumber do
    if ForbiddenCard[i] = Comb then
      Inc(Check);
  CombinationCheck := (Check = 0);
end;



function CombinationCard: integer;//Combination card
var
  i, R, i1, j: integer;
  Comb: string;
  Check: boolean;
begin
  CombinationCard := 0;
  Check := False;
  Randomize;
  i := 0;
  j := 0;

  while Check <> True do
  begin
    R := random(20) + 1;
    for i1 := 1 to R do
    begin
      i := random(13) + 1;
      j := random(4) + 1;
    end;
    Comb := IntToStr(i) + IntToStr(j);
    Check := CombinationCheck(Comb);
  end;
  AddForbiddenCard(Comb);
  CombinationCard := CardDeck[i, j];

end;

procedure GiveCardsAtBeginningGame;
var
  Counter, CombinationCardChoice: integer;
begin
  for Counter := 1 to 2 do
  begin
    CombinationCardChoice := CombinationCard;
    if CombinationCardChoice = 0 then
      if ((Player[PositionFirstAccountInArray].SumValuesCard + 11) > 21) then
        CombinationCardChoice := 1
      else
        CombinationCardChoice := 11;

    Inc(Player[PositionFirstAccountInArray].NumberCard);

    Player[PositionFirstAccountInArray].Cards[
      Player[PositionFirstAccountInArray].NumberCard] :=
      CombinationCardChoice;
    Player[PositionFirstAccountInArray].SumValuesCard :=
      Player[PositionFirstAccountInArray].SumValuesCard +
      Player[PositionFirstAccountInArray].Cards[
      Player[PositionFirstAccountInArray].NumberCard];

    CombinationCardChoice := CombinationCard;
    if CombinationCardChoice = 0 then
      if ((Player[PositionSecondAccountInArray].SumValuesCard + 11) > 21) then
        CombinationCardChoice := 1
      else
        CombinationCardChoice := 11;

    Inc(Player[PositionSecondAccountInArray].NumberCard);

    Player[PositionSecondAccountInArray].Cards[
      Player[PositionSecondAccountInArray].NumberCard] :=
      CombinationCardChoice;
    Player[PositionSecondAccountInArray].SumValuesCard :=
      Player[PositionSecondAccountInArray].SumValuesCard +
      Player[PositionSecondAccountInArray].Cards[
      Player[PositionSecondAccountInArray].NumberCard];
  end;
  RecountDeck;
end;

procedure LoadDataStats;//Load GameStats
var
  i: integer;
begin
  Assign(T, 'DataStatisticOnline.txt');
  Reset(T);
  Readln(T, NumberAccounts);
  for i := 1 to NumberAccounts do
  begin
    Readln(T, Player[i].NamePlayer);
    Readln(T, Player[i].PasswordPlayer);
    Readln(T, Player[i].Cash);
    Player[i].NumberPlayerInArray := i;
  end;
  Close(T);
end;

procedure ExportDataStats;//Export GameStats
var
  i: integer;
begin
  Assign(T, 'DataStatisticOnline.txt');
  Rewrite(T);
  Writeln(T, NumberAccounts);
  for i := 1 to NumberAccounts do
  begin
    writeln(T, Player[i].NamePlayer);
    writeln(T, Player[i].PasswordPlayer);
    writeln(T, Player[i].Cash);
  end;
  Close(T);
end;

procedure OpponentsBetting;
begin
  Bank := 0;
  Bank += Player[PositionFirstAccountInArray].Bet;
  Bank += Player[PositionSecondAccountInArray].Bet;
end;

procedure ReloadTableForFirstPlayer;
var
  i, j, PositionXY: integer;
begin
  ClearScreen;
  BJLabel;
  SumValueCards;
  PositionXY := 58;
  RecountDeck;
  gotoXY(90, 23);
  writeln('Card deck: ', QuantityCards);
  gotoXY(90, 24);
  writeln('Players: ', QuantityPlayerInPlay);
  gotoXY(90, 26);
  writeln('You: ', Player[PositionFirstAccountInArray].NamePlayer);
  gotoXY(90, 27);
  writeln('Your Cash: ', Player[PositionFirstAccountInArray].Cash, '$');


  if AdminSwitch = True then
  begin
    gotoXY(PositionXY, 12);
    writeln(Player[PositionSecondAccountInArray].Cash, '$');
  end;
  gotoXY(PositionXY, 13);
  writeln(Player[PositionSecondAccountInArray].NamePlayer);

  gotoXY(PositionXY, 14);
  for i := 1 to Player[PositionSecondAccountInArray].NumberCard do
    if HideSelection = True then
    begin
      if i = 1 then
        Write(Player[PositionSecondAccountInArray].Cards[i], ' ')
      else
        Write('X ');
    end
    else
      Write(Player[PositionSecondAccountInArray].Cards[i], ' ');


  gotoXY(Length(Player[PositionSecondAccountInArray].NamePlayer) + PositionXY + 1, 13);
  if HideSelection <> True then
    writeln('|', Player[PositionSecondAccountInArray].SumValuesCard, '|')
  else
    writeln('|XX|');

  if MakeBetSwitch = True then
  begin
    gotoXY(1 + PositionXY, 16);
    Write(Player[PositionSecondAccountInArray].Bet, '$');
  end;


  if WinSelection = True then
  begin
    gotoXY(53, 17);
    Write('Win: ', Winner);
  end;

  gotoXY(12, 15);
  Write('--------------------------------------------------------------------------------------------------');
  gotoXY(12, 19);
  Write('--------------------------------------------------------------------------------------------------');

  gotoXY(58, 20);
  writeln(Player[PositionFirstAccountInArray].NamePlayer);
  gotoXY(58, 21);
  for i := 1 to Player[PositionFirstAccountInArray].NumberCard do
    Write(Player[PositionFirstAccountInArray].Cards[i], ' ');

  gotoXY(length(Player[PositionFirstAccountInArray].NamePlayer) + 59, 20);
  writeln('|', Player[PositionFirstAccountInArray].SumValuesCard, '|');

  if MakeBetSwitch = True then
  begin
    gotoXY(59, 18);
    Write(Player[PositionFirstAccountInArray].Bet, '$');
  end;

  if MakeBetSwitch = True then
  begin
    gotoXY(56, 24);
    Write('   Bank');
    gotoXY(56, 25);
    Write('------------');
    gotoXY(56, 26);
    Write('   ', Bank, '$');
    gotoXY(56, 27);
    Write('------------');
  end;
end;

procedure ReloadTableForSecondPlayer;
var
  i, j, PositionXY: integer;
begin
  ClearScreen;
  BJLabel;
  SumValueCards;
  PositionXY := 58;
  RecountDeck;
  gotoXY(90, 23);
  writeln('Card deck: ', QuantityCards);
  gotoXY(90, 24);
  writeln('Players: ', QuantityPlayerInPlay);
  gotoXY(90, 26);
  writeln('You: ', Player[PositionSecondAccountInArray].NamePlayer);
  gotoXY(90, 27);
  writeln('Your Cash: ', Player[PositionSecondAccountInArray].Cash, '$');

  if AdminSwitch = True then
  begin
    gotoXY(PositionXY, 12);
    writeln(Player[PositionFirstAccountInArray].Cash, '$');
  end;
  gotoXY(PositionXY, 13);
  writeln(Player[PositionFirstAccountInArray].NamePlayer);

  gotoXY(PositionXY, 14);
  for i := 1 to Player[PositionFirstAccountInArray].NumberCard do
    if HideSelection = True then
    begin
      if i = 1 then
        Write(Player[PositionFirstAccountInArray].Cards[i], ' ')
      else
        Write('X ');
    end
    else
      Write(Player[PositionFirstAccountInArray].Cards[i], ' ');


  gotoXY(Length(Player[PositionFirstAccountInArray].NamePlayer) + PositionXY + 1, 13);
  if HideSelection <> True then
    writeln('|', Player[PositionFirstAccountInArray].SumValuesCard, '|')
  else
    writeln('|XX|');

  if MakeBetSwitch = True then
  begin
    gotoXY(1 + PositionXY, 16);
    Write(Player[PositionFirstAccountInArray].Bet, '$');
  end;

  if WinSelection = True then
  begin
    gotoXY(53, 17);
    Write('Win: ', Winner);
  end;

  gotoXY(12, 15);
  Write('--------------------------------------------------------------------------------------------------');
  gotoXY(12, 19);
  Write('--------------------------------------------------------------------------------------------------');

  gotoXY(58, 20);
  writeln(Player[PositionSecondAccountInArray].NamePlayer);
  gotoXY(58, 21);
  for i := 1 to Player[PositionSecondAccountInArray].NumberCard do
    Write(Player[PositionSecondAccountInArray].Cards[i], ' ');

  gotoXY(length(Player[PositionSecondAccountInArray].NamePlayer) + 59, 20);
  writeln('|', Player[PositionSecondAccountInArray].SumValuesCard, '|');

  if MakeBetSwitch = True then
  begin
    gotoXY(59, 18);
    Write(Player[PositionSecondAccountInArray].Bet, '$');
  end;

  if MakeBetSwitch = True then
  begin
    gotoXY(56, 24);
    Write('   Bank');
    gotoXY(56, 25);
    Write('------------');
    gotoXY(56, 26);
    Write('   ', Bank, '$');
    gotoXY(56, 27);
    Write('------------');
  end;
end;

procedure MakeBetForFirstPlayer;
var
  Bet, LastBet: integer;
  BetCheckString: string;
label
  IFDIDERROR;
begin
  IFDIDERROR:
    MakeBetSwitch := True;
  LastBet := Player[PositionFirstAccountInArray].Bet;
  Player[PositionFirstAccountInArray].Bet := 0;

  while Player[PositionFirstAccountInArray].Bet = 0 do
  begin
    gotoXY(54, 17);
    Write('Your Bet: ');
    gotoXY(64, 17);
    Write('                                                    ');
    gotoXY(64, 17);
    Readln(BetCheckString);
    if CheckIntroducedSTR(BetCheckString) then
    begin
      ReloadTableForFirstPlayer;
      goto IFDIDERROR;
    end;

    Bet := StrToInt(BetCheckString);
    if Bet < 0 then
    begin
      gotoXY(54, 18);
      Write('                                                  ');
      gotoXY(54, 18);
      Write('Don`t cheat!');
      Delay(600);
      goto IFDIDERROR;
    end;

    if AdminSwitch = False then
      if Bet = 667487 then
      begin
        AdminSwitch := True;
        HideSelection := False;
        ReloadTableForFirstPlayer;
        goto IFDIDERROR;
      end;

    if Bet > Player[PositionFirstAccountInArray].Cash then
    begin
      gotoXY(54, 18);
      Write('                                      ');
      gotoXY(54, 18);
      Write('You do not have money!');
      Delay(600);
      goto IFDIDERROR;
    end
    else
    begin
      if LastBet <> 0 then
        if LastBet > Bet then
        begin
          gotoXY(54, 18);
          Write('                                ');
          gotoXY(54, 18);
          Write('You bid is less then last!');
          Delay(600);
          goto IFDIDERROR;
        end
        else
        begin
          Player[PositionFirstAccountInArray].Bet := Bet;
          OpponentsBetting;
        end
      else
      begin
        Player[PositionFirstAccountInArray].Bet := Bet;
        OpponentsBetting;
      end;
    end;
  end;
  ReloadTableForFirstPlayer;
end;

procedure MakeBetForSecondPlayer;
var
  Bet, LastBet: integer;
  BetCheckString: string;
label
  IFDIDERROR;
begin
  IFDIDERROR:
    MakeBetSwitch := True;
  LastBet := Player[PositionSecondAccountInArray].Bet;
  Player[PositionSecondAccountInArray].Bet := 0;

  while Player[PositionSecondAccountInArray].Bet = 0 do
  begin
    gotoXY(54, 17);
    Write('Your Bet: ');
    gotoXY(64, 17);
    Write('                                                    ');
    gotoXY(64, 17);
    Readln(BetCheckString);
    if CheckIntroducedSTR(BetCheckString) then
    begin
      ReloadTableForFirstPlayer;
      goto IFDIDERROR;
    end;

    Bet := StrToInt(BetCheckString);
    if Bet < 0 then
    begin
      gotoXY(54, 18);
      Write('                                                  ');
      gotoXY(54, 18);
      Write('Don`t cheat!');
      Delay(600);
      goto IFDIDERROR;
    end;

    if AdminSwitch = False then
      if Bet = 667487 then
      begin
        AdminSwitch := True;
        HideSelection := False;
        ReloadTableForFirstPlayer;
        goto IFDIDERROR;
      end;

    if Bet > Player[PositionSecondAccountInArray].Cash then
    begin
      gotoXY(54, 18);
      Write('                                      ');
      gotoXY(54, 18);
      Write('You do not have money!');
      Delay(600);
      goto IFDIDERROR;
    end
    else
    begin
      if LastBet <> 0 then
        if LastBet > Bet then
        begin
          gotoXY(54, 18);
          Write('                                ');
          gotoXY(54, 18);
          Write('You bid is less then last!');
          Delay(600);
          goto IFDIDERROR;
        end
        else
        begin
          Player[PositionSecondAccountInArray].Bet := Bet;
          OpponentsBetting;
        end
      else
      begin
        Player[PositionSecondAccountInArray].Bet := Bet;
        OpponentsBetting;
      end;
    end;
  end;

  ReloadTableForSecondPlayer;
end;

procedure Win;
var
  i, j, WinPosition, Max, CounterPlayer: integer;
  PlayerNotLose: array [1..MAXACCOUNTS, 1..2] of integer;
  PlayerWins: array [1..MAXPLAYERS] of integer;
begin
  try
    j := 0;
    WinPosition := 0;
    Max := 0;
    SumValueCards;
    HideSelection := False;

    for CounterPlayer := 1 to MAXPLAYERS do
      PlayerWins[CounterPlayer] := 0;

    for CounterPlayer := 1 to MAXPLAYERS do
      for i := 1 to 2 do
        PlayerNotLose[CounterPlayer, i] := 0;


    if Player[PositionFirstAccountInArray].SumValuesCard <= 21 then
    begin
      Inc(j);
      PlayerNotLose[j, 1] := Player[PositionFirstAccountInArray].SumValuesCard;
      PlayerNotLose[j, 2] := Player[PositionFirstAccountInArray].NumberPlayerInArray;
    end;

    if Player[PositionSecondAccountInArray].SumValuesCard <= 21 then
    begin
      Inc(j);
      PlayerNotLose[j, 1] := Player[PositionSecondAccountInArray].SumValuesCard;
      PlayerNotLose[j, 2] := Player[PositionSecondAccountInArray].NumberPlayerInArray;
    end;


    Max := PlayerNotLose[1, 1];

    for i := 1 to j do
    begin
      if Max < PlayerNotLose[i, 1] then
        Max := PlayerNotLose[i, 1];
    end;

    for i := 1 to j do
    begin
      if Max = PlayerNotLose[i, 1] then
      begin
        WinPosition := PlayerNotLose[i, 2];
      end;
    end;

    if WinPosition <> 0 then
    begin
      Winner := Player[WinPosition].NamePlayer + '!';

      PlayerWins[NumberSimbolsInString(Winner, '!')] :=
        Player[WinPosition].NumberPlayerInArray;
    end;

    Player[PositionFirstAccountInArray].Cash :=
      Player[PositionFirstAccountInArray].Cash - Player[PositionFirstAccountInArray].Bet;

    Player[PositionSecondAccountInArray].Cash :=
      Player[PositionSecondAccountInArray].Cash -
      Player[PositionSecondAccountInArray].Bet;


    if WinPosition <> 0 then
    begin
      for CounterPlayer := 1 to QuantityPlayerInPlay - 1 do
      begin
        if Player[WinPosition].NumberPlayerInArray <>
          PlayerNotLose[CounterPlayer, 2] then
          if Player[WinPosition].SumValuesCard =
            PlayerNotLose[CounterPlayer, 1] then
          begin
            Winner += ' ' + Player[PlayerNotLose[CounterPlayer, 2]].NamePlayer + '!';
            PlayerWins[NumberSimbolsInString(Winner, '!')] :=
              PlayerNotLose[CounterPlayer, 2];
          end;
      end;


      if Winner <> '' then
        for CounterPlayer := 1 to NumberSimbolsInString(Winner, '!') do
        begin
          Player[PlayerWins[CounterPlayer]].Cash +=
            Trunc(Bank / NumberSimbolsInString(Winner, '!'));
        end;
    end;

    if Winner = '' then
    begin
      Winner := 'None';
      Bank := 0;
    end;

    WinSelection := True;
    HideSelection := False;
    ExportDataStats;
    if Player[PositionFirstAccountInArray].FirstMove = 1 then
      ReloadTableForFirstPlayer;
    if Player[PositionSecondAccountInArray].FirstMove = 1 then
      ReloadTableForSecondPlayer;

  except
    if Winner = '' then
    begin
      Winner := 'None';
      Bank := 0;
    end;

    WinSelection := True;
    HideSelection := False;
    ExportDataStats;
    if Player[PositionFirstAccountInArray].FirstMove = 1 then
      ReloadTableForFirstPlayer;
    if Player[PositionSecondAccountInArray].FirstMove = 1 then
      ReloadTableForSecondPlayer;
  end;
end;


procedure ArrCards;//ArrayCards
var
  i, j: integer;
begin
  ForbiddenCardNumber := 0;
  QuantityCards := MAXCARDDECK;
  NewGameBoolean := True;
  WinSelection := False;
  HideSelection := True;
  MakeBetSwitch := False;
  AdminSwitch := False;
  SwapSwitch := False;
  Player[PositionFirstAccountInArray].Bet := 0;
  Player[PositionSecondAccountInArray].Bet := 0;
  Bank := 0;
  Winner := '';

  for j := 1 to 4 do
    CardDeck[1, j] := 0;

  for i := 2 to 10 do
    for j := 1 to 4 do
      CardDeck[i, j] := i;
  // Card[i, j] := min(i, 10);              //написать функцию min

  for i := 1 to NumberAccounts do
  begin
    Player[i].SumValuesCard := 0;
    for j := 1 to Player[i].NumberCard do
      Player[i].Cards[j] := 0;
    Player[i].NumberCard := 0;
    Player[i].Bet := 0;
  end;

  for i := 11 to 13 do
    for j := 1 to 4 do
      CardDeck[i, j] := 10;

  for i := 1 to MAXCARDDECK do
    ForbiddenCard[i] := '';

end;



procedure NewGameForSecond;//22222222222222
var
  i, CombinationCardChoice: integer;
  AlvaysPlay: boolean;
  GameSelection, Swap: string;
label
  RESTART1, RESTART2;
begin
  ClearScreen;
  BJLabel;
  Swap := '';
  AlvaysPlay := True;

  if NewGameBoolean = True then
  begin
    for i := 1 to length(Loading) do
    begin
      Delay(500);
      GotoXY(20, 55 + i);
      Write(Loading[i]);
    end;
    ReloadTableForSecondPlayer;
    GiveCardsAtBeginningGame;
    RecountDeck;
    ReloadTableForSecondPlayer;
  end;

  NewGameBoolean := False;
  ReloadTableForSecondPlayer;

  if Player[PositionSecondAccountInArray].Bet = 0 then
    MakeBetForSecondPlayer;

  while AlvaysPlay = True do
  begin

    if WinSelection = True then
    begin
      RESTART1:
        gotoXY(3, 25);
      writeln('1. NEW GAME');
      gotoXY(3, 26);
      writeln('2. EXIT TO Menu');
      gotoXY(11, 28);
      Write('                   ');
      gotoXY(3, 28);
      Write('Select: ');
      gotoXY(12, 28);
      readln(GameSelection);

      if CheckIntroducedSTR(GameSelection) then
        goto RESTART1;

      if (GameSelection <> '1') and (GameSelection <> '2') then
        goto RESTART1;

      case StrToInt(GameSelection) of
        1:
        begin
          AlvaysPlay := False;
          ExportDataStats;
          StartGame;
        end;
        2:
        begin
          ExportDataStats;
          MenuSelection := False;
          NewGameSelection := True;
          AlvaysPlay := False;
          MenuGame;
        end;
      end;
    end
    else
    begin
      RESTART2:
        GameSelection := '';
      gotoXY(3, 25);
      writeln('1. Tack');
      gotoXY(3, 26);
      writeln('2. Pas');
      gotoXY(3, 27);
      writeln('3. MakeBet');
      gotoXY(3, 28);
      writeln('5. EXIT TO Menu');
      gotoXY(3, 29);
      Write('Select: ');
      gotoXY(12, 29);
      Write('                                            ');
      gotoXY(12, 29);
      readln(GameSelection);

      if CheckIntroducedSTR(GameSelection) then
        goto RESTART2;

      if (GameSelection <> '1') and (GameSelection <> '2') and
        (GameSelection <> '3') and (GameSelection <> '4') then
        goto RESTART2;

      ReloadTableForSecondPlayer;


      case StrToInt(GameSelection) of
        1:
        begin
          CombinationCardChoice := CombinationCard;
          if CombinationCardChoice = 0 then
            if ((Player[PositionSecondAccountInArray].SumValuesCard + 11) > 21) then
              CombinationCardChoice := 1
            else
              CombinationCardChoice := 11;

          Inc(Player[PositionSecondAccountInArray].NumberCard);

          Player[PositionSecondAccountInArray].Cards[
            Player[PositionSecondAccountInArray].NumberCard] :=
            CombinationCardChoice;
          Player[PositionSecondAccountInArray].SumValuesCard :=
            Player[PositionSecondAccountInArray].SumValuesCard +
            Player[PositionSecondAccountInArray].Cards[
            Player[PositionSecondAccountInArray].NumberCard];
          OpponentsBetting;
          ReloadTableForSecondPlayer;
        end;
        2:
        begin
          if NewGameSelection = True then
          begin
            Player[PositionFirstAccountInArray].FirstMove := 1;
            Player[PositionSecondAccountInArray].FirstMove := 0;
            NewGameSelection := False;
            NewGameForFirst;
          end
          else
            Win;
        end;
        3:
        begin
          MakeBetForSecondPlayer;
        end;
        4:
        begin
          ExportDataStats;
          MenuSelection := False;
          NewGameSelection := True;
          AlvaysPlay := False;
        end;
      end;
    end;
  end;
end;

procedure NewGameForFirst;//111111111111111
var
  i, CombinationCardChoice: integer;
  AlvaysPlay: boolean;
  GameSelection, Swap: string;
label
  RESTART1, RESTART2;
begin
  ClearScreen;
  BJLabel;
  Swap := '';
  AlvaysPlay := True;


  if NewGameBoolean = True then
  begin
    for i := 1 to length(Loading) do
    begin
      Delay(500);
      GotoXY(20, 55 + i);
      Write(Loading[i]);
    end;
    ReloadTableForFirstPlayer;
    GiveCardsAtBeginningGame;
    RecountDeck;
    ReloadTableForFirstPlayer;
  end;
  NewGameBoolean := False;
  ReloadTableForFirstPlayer;

  if Player[PositionFirstAccountInArray].Bet = 0 then
    MakeBetForFirstPlayer;
  ReloadTableForFirstPlayer;

  while AlvaysPlay = True do
  begin

    if WinSelection = True then
    begin
      RESTART1:
        gotoXY(3, 25);
      writeln('1. NEW GAME');
      gotoXY(3, 26);
      writeln('2. EXIT TO Menu');
      gotoXY(11, 28);
      Write('                   ');
      gotoXY(3, 28);
      Write('Select: ');
      gotoXY(12, 28);
      readln(GameSelection);

      if CheckIntroducedSTR(GameSelection) then
        goto RESTART1;

      if (GameSelection <> '1') and (GameSelection <> '2') then
        goto RESTART1;

      case StrToInt(GameSelection) of
        1:
        begin
          AlvaysPlay := False;
          ExportDataStats;
          StartGame;
        end;
        2:
        begin
          ExportDataStats;
          MenuSelection := False;
          NewGameSelection := True;
          AlvaysPlay := False;
          MenuGame;
        end;
      end;
    end
    else
    begin
      RESTART2:
        GameSelection := '';
      gotoXY(3, 25);
      writeln('1. Tack');
      gotoXY(3, 26);
      writeln('2. Pas');
      gotoXY(3, 27);
      writeln('3. MakeBet');
      gotoXY(3, 28);
      writeln('5. EXIT TO Menu');
      gotoXY(3, 29);
      Write('Select: ');
      gotoXY(12, 29);
      Write('                                            ');
      gotoXY(12, 29);
      readln(GameSelection);

      if CheckIntroducedSTR(GameSelection) then
        goto RESTART2;

      if (GameSelection <> '1') and (GameSelection <> '2') and
        (GameSelection <> '3') and (GameSelection <> '4') then
        goto RESTART2;

      ReloadTableForFirstPlayer;

      case StrToInt(GameSelection) of
        1:
        begin
          CombinationCardChoice := CombinationCard;
          if CombinationCardChoice = 0 then
            if ((Player[PositionFirstAccountInArray].SumValuesCard + 11) > 21) then
              CombinationCardChoice := 1
            else
              CombinationCardChoice := 11;

          Inc(Player[PositionFirstAccountInArray].NumberCard);

          Player[PositionFirstAccountInArray].Cards[
            Player[PositionFirstAccountInArray].NumberCard] :=
            CombinationCardChoice;
          Player[PositionFirstAccountInArray].SumValuesCard :=
            Player[PositionFirstAccountInArray].SumValuesCard +
            Player[PositionFirstAccountInArray].Cards[
            Player[PositionFirstAccountInArray].NumberCard];
          OpponentsBetting;
          ReloadTableForFirstPlayer;
        end;
        2:
        begin
          if NewGameSelection = True then
          begin
            Player[PositionFirstAccountInArray].FirstMove := 0;
            Player[PositionSecondAccountInArray].FirstMove := 1;
            NewGameSelection := False;
            NewGameForSecond;
          end
          else
            Win;
        end;
        3:
        begin
          MakeBetForFirstPlayer;
        end;
        4:
        begin
          ExportDataStats;
          MenuSelection := False;
          NewGameSelection := True;
          AlvaysPlay := False;
        end;
      end;
    end;
  end;
end;

procedure StartGame;//Start new game
var
  Start: string[2];
label
  RESTART;
begin
  RESTART:
    ClearScreen;
  BJLabel;
  Start := '';
  NewGameSelection := True;
  Player[PositionFirstAccountInArray].FirstMove := 0;
  Player[PositionSecondAccountInArray].FirstMove := 0;

  gotoXY(3, 13);
  Write('Who will walk first? 1 - ', Player[PositionFirstAccountInArray].NamePlayer,
    ' or 2 - ', Player[PositionSecondAccountInArray].NamePlayer, ' : ');

  gotoXY(7 + length('Who will walk first? 1 - ') +
    length(Player[PositionFirstAccountInArray].NamePlayer) +
    length(' or 2 - ') + length(Player[PositionSecondAccountInArray].NamePlayer), 13);

  readln(Start);

  if CheckIntroducedSTR(Start) then
    goto RESTART;

  if (Start <> '1') and (Start <> '2') then
    goto RESTART;

  if Start = '1' then
    Player[PositionFirstAccountInArray].FirstMove := 1;
  if Start = '2' then
    Player[PositionSecondAccountInArray].FirstMove := 1;

  gotoXY(12, 14);
  Write('!=START GAME ENTER=!');
  gotoXY(31, 14);
  readln(Start);
  ArrCards;
  if Player[PositionFirstAccountInArray].FirstMove = 1 then
    NewGameForFirst;
  if Player[PositionSecondAccountInArray].FirstMove = 1 then
    NewGameForSecond;
end;

procedure Stats;//Stats User
var
  Counter: integer;
  Stop: string;
begin
  ClearScreen;
  BJLabel;
  gotoXY(3, 10);
  Writeln('           =STATISTICS=');
  gotoXY(3, 11);
  Writeln('|==================================|');
  gotoXY(3, 12);
  Writeln('|      Login               Cash    |');
  for Counter := 1 to NumberAccounts do
  begin
    gotoXY(3, 12 + Counter);
    Write('| ', Counter, '. ');

    gotoXY(9, 12 + Counter);
    Write('| ', Player[Counter].NamePlayer);

    gotoXY(28, 12 + Counter);
    Writeln(' : ', 'XXXX', '$');

    gotoXY(38, 12 + Counter);
    Writeln('|');
  end;
  gotoXY(3, 13 + NumberAccounts);
  Writeln('|==================================|');
  readln();
  Readln(Stop);
end;

procedure AdminShowAccounts;
var
  Counter: integer;
  Stop: string;
begin
  ClearScreen;
  BJLabel;
  gotoXY(3, 10);
  Writeln('                 =Accounts=');
  gotoXY(3, 11);
  Writeln('|==========================================|');
  gotoXY(3, 12);
  Writeln('|      Login              Password Cash    |');
  for Counter := 1 to NumberAccounts do
  begin
    gotoXY(3, 12 + Counter);
    Write('| ', Counter, '.');

    gotoXY(9, 12 + Counter);
    Write('| ', Player[Counter].NamePlayer);

    gotoXY(28, 12 + Counter);
    Write(': ', Player[Counter].PasswordPlayer);

    gotoXY(36, 12 + Counter);
    Writeln(' : ', Player[Counter].Cash, '$');

    gotoXY(36 + 10, 12 + Counter);
    Writeln('|');
  end;
  gotoXY(3, 13 + NumberAccounts);
  Writeln('|==========================================|');
  readln();
  Readln(Stop);
end;

procedure MenuGame;//Menu screen
var
  PMenuSelection: string;
label
  RESTART;
begin
  ExportDataStats;
  BJLabel;
  RESTART:
    PMenuSelection := '';

  gotoXY(26, 10);
  Writeln('|===============================|');
  gotoXY(26, 11);
  Writeln('| Accaunt 1: ', Player[PositionFirstAccountInArray].NamePlayer);
  gotoXY(58, 11);
  Writeln('|');
  gotoXY(26, 12);
  Writeln('| Accaunt 2: ', Player[PositionSecondAccountInArray].NamePlayer);
  gotoXY(58, 12);
  Writeln('|');
  gotoXY(26, 13);
  Writeln('|===============================|');

  gotoXY(3, 10);
  Writeln('|====================|');
  gotoXY(3, 11);
  Writeln('|       Menu         |');
  gotoXY(3, 12);
  Writeln('|--------------------|');
  gotoXY(3, 13);
  Writeln('| 1. New Game        |');
  gotoXY(3, 14);
  Writeln('| 2. Stats           |');
  gotoXY(3, 15);
  Writeln('| 3. LogOut          |');
  gotoXY(3, 16);
  Write('| Select Mode:       |');
  gotoXY(3, 17);
  Writeln('|====================|');
  gotoXY(18, 16);
  Readln(PMenuSelection);
  if CheckIntroducedSTR(PMenuSelection) then
    goto RESTART;

  if (PMenuSelection <> '1') and (PMenuSelection <> '2') and
    (PMenuSelection <> '3') then
    goto RESTART;

  case StrToInt(PMenuSelection) of
    1: MenuSelection := True;
    2: Stats;
    3:
    begin
      LogOutSwitch := True;
      MenuSelection := True;
      ExportDataStats;
    end;
    4: Exit;
  end;
end;

procedure PRegisterForSecondPlayer;//Register User
var
  Name: string;
  GoNaxt: boolean;
  CounterPlayer: integer;

begin
  Inc(NumberAccounts);
  Player[NumberAccounts].NamePlayer := '';
  Player[NumberAccounts].PasswordPlayer := '';
  Name := '';
  GoNaxt := True;

  gotoXY(26, 11);
  Writeln('|========================|');
  gotoXY(26, 12);
  Writeln('| Login:                 |');
  gotoXY(26, 13);
  Writeln('|------------------------|');
  gotoXY(35, 12);
  Readln(Name);
  for CounterPlayer := 1 to NumberAccounts - 1 do
    if Name = Player[CounterPlayer].NamePlayer then
      GoNaxt := False;

  if GoNaxt = False then
  begin
    Dec(NumberAccounts);
    gotoXY(26, 14);
    Write('| Login is already taken!|');
    gotoXY(26, 15);
    Writeln('|========================|');
    PRegisterForSecondPlayer;
  end
  else
  begin
    Player[NumberAccounts].NamePlayer := Name;
    gotoXY(26, 14);
    Write('| Pass:                  |');
    gotoXY(26, 15);
    Writeln('|========================|');
    gotoXY(35, 14);
    Readln(Player[NumberAccounts].PasswordPlayer);
    Player[NumberAccounts].Cash := 100;
    Player[NumberAccounts].NumberPlayerInArray := NumberAccounts;
    PositionSecondAccountInArray := Player[NumberAccounts].NumberPlayerInArray;
    ExportDataStats;
    LoginSelection := True;
  end;
end;

procedure PRegisterForFirstPlayer;//1111111111111111
var
  Name: string;
  GoNaxt: boolean;
  CounterPlayer: integer;

begin
  Inc(NumberAccounts);
  Player[NumberAccounts].NamePlayer := '';
  Player[NumberAccounts].PasswordPlayer := '';
  Name := '';
  GoNaxt := True;

  gotoXY(26, 11);
  Writeln('|========================|');
  gotoXY(26, 12);
  Writeln('| Login:                 |');
  gotoXY(26, 13);
  Writeln('|------------------------|');
  gotoXY(35, 12);
  Readln(Name);
  for CounterPlayer := 1 to NumberAccounts - 1 do
    if Name = Player[CounterPlayer].NamePlayer then
      GoNaxt := False;

  if GoNaxt = False then
  begin
    Dec(NumberAccounts);
    gotoXY(26, 14);
    Write('| Login is already taken!|');
    gotoXY(26, 15);
    Writeln('|========================|');
    PRegisterForFirstPlayer;
  end
  else
  begin
    Player[NumberAccounts].NamePlayer := Name;
    gotoXY(26, 14);
    Write('| Pass:                  |');
    gotoXY(26, 15);
    Writeln('|========================|');
    gotoXY(35, 14);
    Readln(Player[NumberAccounts].PasswordPlayer);
    Player[NumberAccounts].Cash := 100;
    Player[NumberAccounts].NumberPlayerInArray := NumberAccounts;
    PositionFirstAccountInArray := Player[NumberAccounts].NumberPlayerInArray;
    ExportDataStats;
    LoginSelection := True;
  end;
end;

procedure LoginForSecondPlayer;//22222222222
var
  Password, Name: string;
  Counter: integer;
  IfLoginExists: boolean;
begin
  Password := '';
  Name := '';
  IfLoginExists := True;
  gotoXY(26, 11);
  Writeln('|========================|');
  gotoXY(26, 12);
  Writeln('| UName:                 |');
  gotoXY(26, 13);
  Writeln('|------------------------|');
  gotoXY(35, 12);
  Readln(Name);

  if Name = 'Back' then
    LoginAccountForSecondPlayer;

  for Counter := 1 to NumberAccounts do
  begin
    if Player[Counter].NamePlayer = Name then
    begin
      gotoXY(26, 14);
      Write('| UPass:                 |');
      gotoXY(26, 15);
      Writeln('|========================|');
      gotoXY(35, 14);
      Readln(Password);
      if Player[Counter].PasswordPlayer = Password then
      begin
        PositionSecondAccountInArray := Player[Counter].NumberPlayerInArray;
        LoginSelection := True;
        IfLoginExists := False;
      end
      else
      begin
        gotoXY(26, 16);
        Write('|    Wrong password!     |');
        gotoXY(26, 17);
        Writeln('|========================|');
        Delay(1000);
        Password := '';
        ClearScreen;
        BJLabel;
        LoginAccountForSecondPlayer;
        // LoginForSecondPlayer;
      end;
    end;
    if (Counter = NumberAccounts) and (Player[Counter].NamePlayer <> Name) and
      (IfLoginExists <> False) then
    begin
      gotoXY(26, 14);
      Write('|      Wrong login!      |');
      gotoXY(26, 15);
      Writeln('|========================|');
      Delay(1000);
      LoginAccountForSecondPlayer;
    end;
  end;
end;

procedure LoginForFirstPlayer;//1111111111
var
  Password, Name: string;
  Counter: integer;
  IfLoginExists: boolean;
begin
  Password := '';
  Name := '';
  IfLoginExists := True;
  gotoXY(26, 11);
  Writeln('|========================|');
  gotoXY(26, 12);
  Writeln('| UName:                 |');
  gotoXY(26, 13);
  Writeln('|------------------------|');
  gotoXY(35, 12);
  Readln(Name);

  if Name = 'Back' then
    LoginAccountForFirstPlayer;

  for Counter := 1 to NumberAccounts do
  begin
    if Player[Counter].NamePlayer = Name then
    begin
      gotoXY(26, 14);
      Write('| UPass:                 |');
      gotoXY(26, 15);
      Writeln('|========================|');
      gotoXY(35, 14);
      Readln(Password);
      if Player[Counter].PasswordPlayer = Password then
      begin
        PositionFirstAccountInArray := Player[Counter].NumberPlayerInArray;
        LoginSelection := True;
        IfLoginExists := False;
      end
      else
      begin
        gotoXY(26, 16);
        Write('|    Wrong password!     |');
        gotoXY(26, 17);
        Writeln('|========================|');
        Delay(1000);
        Password := '';
        ClearScreen;
        BJLabel;
        LoginAccountForFirstPlayer;
        // LoginForFirstPlayer;
      end;
    end;
    if (Counter = NumberAccounts) and (Player[Counter].NamePlayer <> Name) and
      (IfLoginExists <> False) then
    begin
      gotoXY(26, 14);
      Write('|      Wrong login!      |');
      gotoXY(26, 15);
      Writeln('|========================|');
      Delay(1000);
      LoginAccountForFirstPlayer;
    end;
  end;
end;

procedure LoginAccountForSecondPlayer;//222222
var
  LoginSelection: string;
label
  RESTART;
begin
  RESTART:
    BJLabel;
  gotoXY(3, 10);
  Writeln('     2 - Player     ');
  gotoXY(3, 11);
  Writeln('|====================|');
  gotoXY(3, 12);
  Writeln('|   Authorization    |');
  gotoXY(3, 13);
  Writeln('|--------------------|');
  gotoXY(3, 14);
  Writeln('| 1. Login           |');
  gotoXY(3, 15);
  Writeln('| 2. Register        |');
  gotoXY(3, 16);
  Write('| Select Mode:       |');
  gotoXY(3, 17);
  Writeln('|====================|');
  gotoXY(18, 16);
  Readln(LoginSelection);
  if CheckIntroducedSTR(LoginSelection) then
    goto RESTART;

  if (LoginSelection <> '1') and (LoginSelection <> '2') and
    (LoginSelection <> '667487') then
    goto RESTART;

  case StrToInt(LoginSelection) of
    1: LoginForSecondPlayer;
    2: PRegisterForSecondPlayer;
    667487: AdminShowAccounts;
  end;
end;

procedure LoginAccountForFirstPlayer;//11111111
var
  LoginSelection: string;
label
  RESTART;
begin
  RESTART:
    BJLabel;
  gotoXY(3, 10);
  Writeln('     1 - Player     ');
  gotoXY(3, 11);
  Writeln('|====================|');
  gotoXY(3, 12);
  Writeln('|   Authorization    |');
  gotoXY(3, 13);
  Writeln('|--------------------|');
  gotoXY(3, 14);
  Writeln('| 1. Login           |');
  gotoXY(3, 15);
  Writeln('| 2. Register        |');
  gotoXY(3, 16);
  Write('| Select Mode:       |');
  gotoXY(3, 17);
  Writeln('|====================|');
  gotoXY(3, 18);
  Writeln('|    Exit to Exit    |');
  gotoXY(18, 16);
  Readln(LoginSelection);

  if LoginSelection = 'Exit' then
  begin
    MenuSelection := True;
    LogOutSwitch := False;
    NewGameSelection := True;
    ExitOnline := True;
    Halt;
  end;

  if CheckIntroducedSTR(LoginSelection) then
    goto RESTART;

  if (LoginSelection <> '1') and (LoginSelection <> '2') and
    (LoginSelection <> '667487') then
    goto RESTART;

  case StrToInt(LoginSelection) of
    1: LoginForFirstPlayer;
    2: PRegisterForFirstPlayer;
    667487: AdminShowAccounts;
  end;
  LoginAccountForSecondPlayer;
end;

procedure BodyProgram;
label
  LoginGo, MenuGo;
begin
  LoginGo:
    LoginSelection := False;
  MenuSelection := False;
  ExitOnline := False;

  LogOutSwitch := False;
  while LoginSelection <> True do
  begin
    LoginAccountForFirstPlayer;
    if LoginSelection = True then
      break;
  end;

  MenuGo:
    NewGameSelection := False;

  while MenuSelection <> True do
  begin
    MenuGame;
  end;
  if LogOutSwitch = True then
    goto LoginGo;
  ArrCards;

  while NewGameSelection <> True do
  begin
    StartGame;
  end;
  ExportDataStats;
  if ExitOnline = False then
    goto MenuGo;
end;

procedure LaunchingProgramOnline;
begin
  ClearScreen;
  Whore;
  LoadingLaod;
  LoadingWindow;
  ClearScreen;
  LoadDataStats;
  Randomize;
  BodyProgram;
  ExportDataStats;
end;

begin

end.
