program BJW;

{$mode objfpc}{$H+}
{$CODEPAGE CP866}
{$codepage UTF8}
uses
  CRT,
  SysUtils;

const
  Loading = '. . .';
  MAXPLAYERS = 8;
  MAXBOTS = 7;
  MAXACCOUNTS = 30;
  MAXPLAYERCARDS = 6;
  MAXCARDDECK = 52;

type
  TSuit = (sDiamonds, sHearts, sSpades, sClubs);


type
  TPlayer = record
    Cards: array [1..MAXPLAYERCARDS] of integer;    //Массив карт
    SumValuesCard: word;                            //Сумма всех карт
    NumberCard: 0..MAXPLAYERCARDS;                  //Количество карт
    Cash: integer;                                  //Бабло
    Bet: integer;                                   //Ставка игрока
    NamePlayer: string;                             //Имя игрока
    PasswordPlayer: string;                         //Пароль игрока
    NumberPlayerInArray: word;                      //Порядковый номер игрока в файле
  end;


var
  Winner: string;     //много стрингов
  MenuSelection, LoginSelection, NewGameSelection, NewGameBoolean,
  WinSelection, HideSelection, MakeBetSwitch, LogOutSwitch: boolean;
  Player: array [1..MAXACCOUNTS] of TPlayer;
  CardDeck: array[1..13, 1..4] of integer;
  WhatPlayersInGame: array[1..MAXBOTS] of word;
  ForbiddenCard: array[1..MAXCARDDECK] of string;
  NumberAccounts, PositionAccountInArray, QuantityCards, QuantityPlayerInPlay,
  ForbiddenCardNumber, Bank: integer;
  T: Text;

  procedure BJLabel;//Show Label
  begin
    textbackground(Green);
    clrscr;
    gotoxy(35, 1);
    Writeln('██████████████████████████████████████████████████████');
    gotoxy(35, 2);
    Writeln('█    ███ ████    ██    ██ ██ ████  ██    ██    ██ ██ █');
    gotoxy(35, 3);
    Writeln('█ ██  ██ ████ ██ ██ ██ ██ █ ██████ ██ ██ ██ ██ ██ █ ██');
    gotoxy(35, 4);
    Writeln('█    ███ ████    ██ █████  ███████ ██    ██ █████  ███');
    gotoxy(35, 5);
    Writeln('█ ██  ██ ████ ██ ██ ██ ██ █ ███ ██ ██ ██ ██ ██ ██ █ ██');
    gotoxy(35, 6);
    Writeln('█    ███   ██ ██ ██    ██ ██ ██    ██ ██ ██    ██ ██ █');
    gotoxy(35, 7);
    Writeln('██████████████████████████████████████████████████████');
  end;

  procedure LoadingWindow;//Home screen setup
  var
    i: integer;
    Start: string;
  begin
    BJLabel;
    gotoxy(57, 10);
    Write('Loading ');
    for i := 1 to length(Loading) do
    begin
      Delay(200);
      Write(Loading[i]);
      Delay(200);
    end;
    gotoxy(54, 12);
    Writeln('Enter to start');
    Readln(Start);
  end;

  procedure ClearScreen;//Clear Screen
  begin
    ClrScr;
  end;

  function OptimalRateTakingIntoAccountSumValueCards(NumberPlayer: integer): integer;
  var
    Counter: integer;
  begin
    OptimalRateTakingIntoAccountSumValueCards := 0;
    if (Player[NumberPlayer].Cash > 0) and (Player[NumberPlayer].Bet >= 0) and
      (Player[NumberPlayer].SumValuesCard < 22) then
    begin
      if Player[NumberPlayer].SumValuesCard = 21 then
        OptimalRateTakingIntoAccountSumValueCards := Player[NumberPlayer].Cash;
      if Player[NumberPlayer].SumValuesCard = 20 then
        OptimalRateTakingIntoAccountSumValueCards :=
          Round(Player[NumberPlayer].Cash * 0.8);
      if Player[NumberPlayer].SumValuesCard = 19 then
        OptimalRateTakingIntoAccountSumValueCards :=
          Round(Player[NumberPlayer].Cash * 0.7);
      if Player[NumberPlayer].SumValuesCard = 18 then
        OptimalRateTakingIntoAccountSumValueCards :=
          Round(Player[NumberPlayer].Cash * 0.5);
      if Player[NumberPlayer].SumValuesCard = 17 then
        OptimalRateTakingIntoAccountSumValueCards :=
          Round(Player[NumberPlayer].Cash * 0.3);
      if Player[NumberPlayer].SumValuesCard < 17 then
        for Counter := 2 to Player[NumberPlayer].SumValuesCard do
          if Player[NumberPlayer].SumValuesCard = Counter then
            OptimalRateTakingIntoAccountSumValueCards :=
              Round(Player[NumberPlayer].Cash * 0.1);

      OptimalRateTakingIntoAccountSumValueCards :=
        ABS(OptimalRateTakingIntoAccountSumValueCards);
    end;

    if OptimalRateTakingIntoAccountSumValueCards = 0 then
      OptimalRateTakingIntoAccountSumValueCards := Player[NumberPlayer].Bet;
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

  procedure Hide;
  var
    PlayerCounter, PositionXY: integer;
  begin
    PositionXY := 35;

    for PlayerCounter := 1 to QuantityPlayerInPlay - 1 do
    begin
      gotoXY(PositionXY + Length(Player[WhatPlayersInGame[PlayerCounter]].NamePlayer) + 1, 13);
      Write('|XX|');
      gotoXY(PositionXY, 14);
      Write('XXXXX');
      PositionXY += Length(Player[WhatPlayersInGame[PlayerCounter]].NamePlayer) + 6;
    end;
  end;

  procedure SumValueCards;
  var
    Counter, CounterNumberCard: integer;
  begin
    for Counter := 1 to QuantityPlayerInPlay - 1 do
    begin
      Player[WhatPlayersInGame[Counter]].SumValuesCard := 0;
      for CounterNumberCard := 1 to Player[WhatPlayersInGame[Counter]].NumberCard do
      begin
        Player[WhatPlayersInGame[Counter]].SumValuesCard :=
          Player[WhatPlayersInGame[Counter]].SumValuesCard +
          Player[WhatPlayersInGame[Counter]].Cards[CounterNumberCard];
      end;
    end;

    Player[PositionAccountInArray].SumValuesCard := 0;

    for CounterNumberCard := 1 to Player[PositionAccountInArray].NumberCard do
    begin
      Player[PositionAccountInArray].SumValuesCard :=
        Player[PositionAccountInArray].SumValuesCard +
        Player[PositionAccountInArray].Cards[CounterNumberCard];
    end;
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
    Dec(QuantityCards);
    Check := False;
    Randomize;
    i := 0;
    j := 0;

    while Check <> True do
    begin
      R := random(20);
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

  procedure LoadDataStats;//Load GameStats
  var
    i: integer;
  begin
    Assign(T, 'DataStatistic.txt');
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
    Assign(T, 'DataStatistic.txt');
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
  var
    CounterPlayer: integer;
  begin
    Bank := 0;

    for  CounterPlayer := 1 to QuantityPlayerInPlay - 1 do
    begin
      Player[WhatPlayersInGame[CounterPlayer]].Bet :=
        OptimalRateTakingIntoAccountSumValueCards(WhatPlayersInGame[CounterPlayer]);
    end;

    for  CounterPlayer := 1 to QuantityPlayerInPlay - 1 do
      Bank += Player[WhatPlayersInGame[CounterPlayer]].Bet;

    Bank += Player[PositionAccountInArray].Bet;

  end;

  procedure ReloadTable;
  var
    i, j, PositionXY: integer;
  begin
    ClearScreen;
    BJLabel;
    SumValueCards;
    PositionXY := 12;
    gotoXY(100, 2);
    writeln('Card deck: ', QuantityCards);
    gotoXY(100, 3);
    writeln('Players: ', QuantityPlayerInPlay);
    gotoXY(100, 5);
    writeln('You: ', Player[PositionAccountInArray].NamePlayer);
    gotoXY(100, 6);
    writeln('Your Cash: ', Player[PositionAccountInArray].Cash, '$');

    for j := 1 to QuantityPlayerInPlay - 1 do
    begin
      gotoXY(PositionXY, 12);
      writeln(Player[WhatPlayersInGame[j]].Cash, '$');
      gotoXY(PositionXY, 13);
      writeln(Player[WhatPlayersInGame[j]].NamePlayer);
      gotoXY(PositionXY, 14);
      for i := 1 to Player[WhatPlayersInGame[j]].NumberCard do
        Write(Player[WhatPlayersInGame[j]].Cards[i], ' ');

      gotoXY(Length(Player[WhatPlayersInGame[j]].NamePlayer) + PositionXY + 1, 13);
      writeln('|', Player[WhatPlayersInGame[j]].SumValuesCard, '|');
      if MakeBetSwitch = True then
      begin
        gotoXY(1 + PositionXY, 16);
        Write(Player[WhatPlayersInGame[j]].Bet, '$');
      end;
      PositionXY += Length(Player[WhatPlayersInGame[j]].NamePlayer) + 7;
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
    writeln(Player[PositionAccountInArray].NamePlayer);
    gotoXY(58, 21);
    for i := 1 to Player[PositionAccountInArray].NumberCard do
      Write(Player[PositionAccountInArray].Cards[i], ' ');

    gotoXY(length(Player[PositionAccountInArray].NamePlayer) + 59, 20);
    writeln('|', Player[PositionAccountInArray].SumValuesCard, '|');

    if MakeBetSwitch = True then
    begin
      gotoXY(59, 18);
      Write(Player[PositionAccountInArray].Bet, '$');
    end;

    if MakeBetSwitch = True then
    begin
      gotoXY(100, 22);
      Write('   Bank');
      gotoXY(100, 23);
      Write('------------');
      gotoXY(100, 24);
      Write('   ', Bank, '$');
      gotoXY(100, 25);
      Write('------------');
    end;

    //Hide;
  end;


  procedure MakeBet;
  var
    Bet: integer;
  label
    IFDIDERROR;
  begin
    IFDIDERROR:
      MakeBetSwitch := True;
    Player[PositionAccountInArray].Bet := 0;
    while Player[PositionAccountInArray].Bet = 0 do
    begin
      gotoXY(54, 17);
      Write('Your Bet: ');
      gotoXY(54, 18);
      Write('                        ');
      gotoXY(54, 18);
      Readln(Bet);
      Bet := ABS(Bet);

      if Bet > Player[PositionAccountInArray].Cash then
      begin
        gotoXY(54, 18);
        Write('You do not have money!');
        Delay(600);
        goto IFDIDERROR;
      end
      else
      begin
        Player[PositionAccountInArray].Bet := Bet;
        OpponentsBetting;
      end;
    end;

    ReloadTable;
  end;

  procedure Win;
  var
    i, j, WinPosition, Max, CounterPlayer: integer;
    PlayerNotLose: array [1..MAXACCOUNTS, 1..2] of integer;
    PlayerWins: array [1..MAXPLAYERS] of integer;
  begin
    j := 0;
    WinPosition := 0;
    SumValueCards;

    for i := 1 to QuantityPlayerInPlay - 1 do
    begin
      if Player[WhatPlayersInGame[i]].SumValuesCard <= 21 then
      begin
        Inc(j);
        PlayerNotLose[j, 1] := Player[WhatPlayersInGame[i]].SumValuesCard;
        PlayerNotLose[j, 2] := Player[WhatPlayersInGame[i]].NumberPlayerInArray;
      end;
    end;

    if Player[PositionAccountInArray].SumValuesCard <= 21 then
    begin
      Inc(j);
      PlayerNotLose[j, 1] := Player[PositionAccountInArray].SumValuesCard;
      PlayerNotLose[j, 2] := PositionAccountInArray;
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

    Winner := Player[WinPosition].NamePlayer + '!';

    PlayerWins[NumberSimbolsInString(Winner, '!')] :=
      Player[WinPosition].NumberPlayerInArray;

    Player[PositionAccountInArray].Cash :=
      Player[PositionAccountInArray].Cash - Player[PositionAccountInArray].Bet;

    for  CounterPlayer := 1 to QuantityPlayerInPlay - 1 do
    begin
      Player[WhatPlayersInGame[CounterPlayer]].Cash :=
        Player[WhatPlayersInGame[CounterPlayer]].Cash -
        Player[WhatPlayersInGame[CounterPlayer]].Bet;
    end;



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

    if Winner = '!' then
    begin
      Winner := 'None';
      Bank := 0;
    end;

    WinSelection := True;
    HideSelection := False;
    ExportDataStats;
    ReloadTable;
  end;

  procedure TakeCardBots;
  var
    Chance, PlayerCounter, CombinationCardChoice: integer;
  begin
    for PlayerCounter := 1 to QuantityPlayerInPlay - 1 do
    begin

      CombinationCardChoice := CombinationCard;
      if CombinationCardChoice = 0 then
        if ((Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard +
          11) > 21) then
          CombinationCardChoice := 1
        else
          CombinationCardChoice := 11;


      if Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard <= 11 then
      begin
        Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
        Player[WhatPlayersInGame[PlayerCounter]].Cards[
          Player[WhatPlayersInGame[PlayerCounter]].NumberCard] := CombinationCardChoice;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard >= 12) and
        (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard <= 15) then
      begin
        Chance := random(2);
        if Chance <> 0 then
          Chance := random(2);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard = 15) then
      begin
        Chance := random(2);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard = 16) then
      begin
        Chance := random(5);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard = 17) then
      begin
        Chance := random(11);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard = 18) then
      begin
        Chance := random(31);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end

      else if (Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard = 19) then
      begin
        Chance := random(51);
        if Chance = 0 then
        begin
          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);
          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;
        end;
      end;

    end;
    ReloadTable;
  end;

  procedure CheckLoos;
  begin
    SumValueCards;
    if Player[PositionAccountInArray].SumValuesCard > 21 then
    begin
      TakeCardBots;
      TakeCardBots;
      Win;
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
    Bank := 0;

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



  procedure NewGame;//Start new game
  var
    i, PlayerCounter, CombinationCardChoice: integer;
    AlvaysPlay: boolean;
    GameSelection: string;
  label
    RESTART1, RESTART2;
  begin
    ClearScreen;
    BJLabel;

    AlvaysPlay := True;

    if NewGameBoolean = True then
    begin
      for PlayerCounter := 1 to QuantityPlayerInPlay - 1 do
      begin
        for i := 1 to 2 do
        begin
          CombinationCardChoice := CombinationCard;
          if CombinationCardChoice = 0 then
            if ((Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard +
              11) > 21) then
              CombinationCardChoice := 1
            else
              CombinationCardChoice := 11;

          Inc(Player[WhatPlayersInGame[PlayerCounter]].NumberCard);

          Player[WhatPlayersInGame[PlayerCounter]].Cards[
            Player[WhatPlayersInGame[PlayerCounter]].NumberCard] :=
            CombinationCardChoice;

          Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard :=
            Player[WhatPlayersInGame[PlayerCounter]].SumValuesCard +
            Player[WhatPlayersInGame[PlayerCounter]].Cards[Player[WhatPlayersInGame[PlayerCounter]].NumberCard];
        end;
      end;

      for i := 1 to 2 do
      begin
        CombinationCardChoice := CombinationCard;
        if CombinationCardChoice = 0 then
          if ((Player[PositionAccountInArray].SumValuesCard + 11) > 21) then
            CombinationCardChoice := 1
          else
            CombinationCardChoice := 11;

        Inc(Player[PositionAccountInArray].NumberCard);

        Player[PositionAccountInArray].Cards[
          Player[PositionAccountInArray].NumberCard] :=
          CombinationCardChoice;
        Player[PositionAccountInArray].SumValuesCard :=
          Player[PositionAccountInArray].SumValuesCard +
          Player[PositionAccountInArray].Cards[
          Player[PositionAccountInArray].NumberCard];
      end;

      for i := 1 to length(Loading) do
      begin
        Delay(500);
        GotoXY(20, 55 + i);
        Write(Loading[i]);
      end;
      ReloadTable;
    end;

    NewGameBoolean := False;
    MakeBet;
    while AlvaysPlay = True do
      //-------------------------------------------------------------
    begin

      if WinSelection = True then
      begin
        RESTART1:
          gotoXY(3, 25);
        writeln('1. NEW GAME');
        gotoXY(3, 26);
        writeln('2. EXIT TO Menu');
        gotoXY(3, 28);
        Write('Select: ');
        gotoXY(12, 28);
        readln(GameSelection);
        if CheckIntroducedSTR(GameSelection) then
          goto RESTART1;

        case StrToInt(GameSelection) of
          1:
          begin
            AlvaysPlay := False;
            ArrCards;
            NewGame;
          end;
          2:
          begin
            ExportDataStats;
            MenuSelection := False;
            NewGameSelection := True;
            AlvaysPlay := False;
          end;
        end;
      end
      else
      begin
        RESTART2:
          gotoXY(3, 25);
        writeln('1. Tack');
        gotoXY(3, 26);
        writeln('2. Pas');
        gotoXY(3, 27);
        writeln('3. MakeBet');
        gotoXY(3, 28);
        writeln('4. EXIT TO Menu');
        gotoXY(3, 29);
        Write('Select: ');
        gotoXY(12, 29);
        readln(GameSelection);
        if CheckIntroducedSTR(GameSelection) then
          goto RESTART2;

        case StrToInt(GameSelection) of
          1:
          begin
            CombinationCardChoice := CombinationCard;
            if CombinationCardChoice = 0 then
              if ((Player[PositionAccountInArray].SumValuesCard + 11) > 21) then
                CombinationCardChoice := 1
              else
                CombinationCardChoice := 11;

            Inc(Player[PositionAccountInArray].NumberCard);

            Player[PositionAccountInArray].Cards[
              Player[PositionAccountInArray].NumberCard] :=
              CombinationCardChoice;
            Player[PositionAccountInArray].SumValuesCard :=
              Player[PositionAccountInArray].SumValuesCard +
              Player[PositionAccountInArray].Cards[
              Player[PositionAccountInArray].NumberCard];
            TakeCardBots;
            OpponentsBetting;
            CheckLoos;
            ReloadTable;
          end;
          2:
          begin
            TakeCardBots;
            TakeCardBots;
            Win;
          end;
          3: MakeBet;
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
    Start, PositionU: string;
    Number, RandomNumber, Counter, RandomCounter: integer;
  label
    RESTART;
  begin
    RESTART:
      Number := 0;
    PositionU := '';
    ClearScreen;
    BJLabel;
    Write('Number of players "2-', MAXPLAYERS, '" : ');
    readln(QuantityPlayerInPlay);
    if CheckIntroducedSTR(IntToStr(QuantityPlayerInPlay)) then
      goto RESTART;

    while Number <> QuantityPlayerInPlay - 1 do
    begin
      RandomCounter := random(20) + 1;

      for Counter := 1 to RandomCounter do
      begin
        RandomNumber := Random(NumberAccounts) + 1;
      end;

      if RandomNumber <> PositionAccountInArray then
      begin
        if pos(Player[RandomNumber].NamePlayer, PositionU) = 0 then
        begin
          Inc(Number);
          WhatPlayersInGame[Number] := RandomNumber;
          PositionU += Player[RandomNumber].NamePlayer;
        end;
      end;
    end;

    Write('!=START ENTER=!');
    readln(Start);
    ArrCards;
    NewGame;
  end;

  procedure Stats;//Stats User
  var
    Counter: integer;
    Stop: string;
  begin
    ClearScreen;
    BJLabel;

    for Counter := 1 to NumberAccounts do
    begin
      Writeln(Player[Counter].NamePlayer, ': ', Player[Counter].Cash, '$');
    end;
    Write('!--!');
    Readln(Stop);
  end;

  procedure MenuGame;//Menu screen
  var
    PMenuSelection: string;
  label
    RESTART;
  begin
    RESTART:
      BJLabel;
    gotoxy(28, 8);

    Writeln('Accaunt: ', Player[PositionAccountInArray].NamePlayer,
      ' |Cash: ', Player[PositionAccountInArray].Cash, '$');
    Writeln('Menu');
    Writeln('1. New Game');
    Writeln('2. Stats');
    Writeln('3. LogOut');
    Write('Select Mode: ');
    Read(PMenuSelection);
    if CheckIntroducedSTR(PMenuSelection) then
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

  procedure PRegister;//Register User     //служебное слово
  begin
    Inc(NumberAccounts);
    Player[NumberAccounts].NamePlayer := '';
    Player[NumberAccounts].PasswordPlayer := '';
    Write('Login: ');
    Readln(Player[NumberAccounts].NamePlayer);
    Write('Pass: ');
    Readln(Player[NumberAccounts].PasswordPlayer);
    Player[NumberAccounts].Cash := 100;
    Player[NumberAccounts].NumberPlayerInArray := NumberAccounts;
    PositionAccountInArray := Player[NumberAccounts].NumberPlayerInArray;
    ExportDataStats;
    LoginSelection := True;
  end;


  procedure Login;//Login User
  var
    Password, Name: string;
    Counter: integer;
    IfLoginExists: boolean;
  begin
    Password := '';
    Name := '';
    IfLoginExists := True;
    Write('UName: ');
    Readln(Name);
    for Counter := 1 to NumberAccounts do
    begin
      if Player[Counter].NamePlayer = Name then
      begin
        Write('UPass: ');
        Readln(Password);
        if Player[Counter].PasswordPlayer = Password then
        begin
          PositionAccountInArray := Player[Counter].NumberPlayerInArray;
          LoginSelection := True;
          IfLoginExists := False;
        end
        else
        begin
          Write('Wrong password!');
          Delay(1000);
          ClearScreen;
          BJLabel;
          Writeln('1. Login');
          Writeln('2. Register');
          Writeln('Select Mode: 1');
          Login;
        end;
      end;
      if (Counter = NumberAccounts) and (Player[Counter].NamePlayer <> Name) and
        (IfLoginExists <> False) then
      begin
        Writeln('Wrong login!');
        Delay(1000);
      end;
    end;
  end;

  procedure LoginAccount;//Login Screen
  var
    LoginSelection: string;
  label
    RESTART;
  begin
    RESTART:
      BJLabel;
    Writeln('1. Login');
    Writeln('2. Register');
    Write('Select Mode: ');
    Readln(LoginSelection);
    if CheckIntroducedSTR(LoginSelection) then
      goto RESTART;

    case StrToInt(LoginSelection) of
      1: Login;
      2: PRegister;
    end;

  end;

  procedure BodyProgram;
  label
    LoginGo, MenuGo;
  begin
    LoginGo:
      LoginSelection := False;
    MenuSelection := False;

    LogOutSwitch := False;
    while LoginSelection <> True do
    begin
      LoginAccount;
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
    goto MenuGo;
  end;

  procedure LaunchingProgram;
  begin
    LoadingWindow;
    ClearScreen;
    LoadDataStats;
    Randomize;
    BodyProgram;
    ExportDataStats;
  end;

begin
  LaunchingProgram;
end.
