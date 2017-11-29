program BJW;

{$mode objfpc}{$H+}
{$CODEPAGE CP866}
{$codepage UTF8}
uses
  CRT,
  SysUtils;

const
  Loading = '. . .';
type
  Comb = array[1..100, 1..20] of integer;
label
  LoginGo, MenuGo;
var
  i, MenuMod, LoginMod: integer;                              //1 - Черви
  Start, Name, Winner: string;                                           //2 - Буби
  MenuError, LoginError, NewGameError, NewGameBool, WinSel, HideMode,
  MakeBetSw, MS: boolean;
  //3 - Крести
  User: array[1..100, 1..3] of string;                           //4 - Пики
  Card: array[1..13, 1..4] of integer;
  CombinationPlayer: Comb;
  ForbiddenCard: array[1..100] of string;
  NumberPlayers, Cash, Position, QuantityCards, QuantityPlayerInPlay,
  ForbiddenCardNum, Bank: integer;
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



  procedure Hide;
  var
    Player: integer;
  begin
    for Player := 2 to QuantityPlayerInPlay do
    begin
      case Player of
        2:
        begin
          if HideMode = True then
          begin
            gotoXY(57, 14);
            Write('XXXXX');
            gotoXY(61, 13);
            Write('|XX|');
          end;
        end;
        3:
        begin
          if HideMode = True then
          begin
            gotoXY(42, 14);
            Write('XXXXX');
            gotoXY(45, 13);
            Write('|XX|');
          end;
        end;
        4:
        begin
          if HideMode = True then
          begin
            gotoXY(73, 14);
            Write('XXXXX');
            gotoXY(76, 13);
            Write('|XX|');
          end;
        end;
      end;
    end;
  end;

  procedure AddForbiddenCard(Comb: string);//AddForbiddenCard
  begin
    Inc(ForbiddenCardNum);
    ForbiddenCard[ForbiddenCardNum] := Comb;
  end;

  function CombinationCheck(Comb: string): boolean;//combination check
  var
    i, Check: integer;
  begin
    Check := 0;
    for i := 1 to ForbiddenCardNum do
      if ForbiddenCard[i] = Comb then
        Inc(Check);
    CombinationCheck := (Check = 0);
  end;



  function CombinationCard(N: integer): integer;//Combination card
  var
    i, R,i1, j, InI: integer;
    Comb: string;
    Check: boolean;
  begin
    CombinationCard := 0;
    for InI := 1 to N do
    begin
      Dec(QuantityCards);
      Check := False;
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
        if Card[i, j] = 0 then
          Check := False;
      end;
      AddForbiddenCard(Comb);
      CombinationCard := Card[i, j];
    end;
  end;

  procedure LoadDataStats;//Load GameStats
  var
    i: integer;
  begin
    Assign(T, 'DataStatistic.txt');
    Reset(T);
    Readln(T, NumberPlayers);
    for i := 1 to NumberPlayers do
    begin
      Readln(T, User[i, 1]);
      Readln(T, User[i, 2]);
      Readln(T, User[i, 3]);
    end;
    Close(T);
  end;

  procedure ExportDataStats;//Export GameStats
  var
    i: integer;
  begin
    Assign(T, 'DataStatistic.txt');
    Rewrite(T);
    Writeln(T, NumberPlayers);
    for i := 1 to NumberPlayers do
    begin
      writeln(T, User[i, 1]);
      writeln(T, User[i, 2]);
      writeln(T, User[i, 3]);
    end;
    Close(T);
  end;

  procedure ReloadTable(QuantityCards: integer; QuantityPlayerInPlay: integer);
  var
    i, j: integer;
  begin
    ClearScreen;
    BJLabel;
    gotoXY(100, 10);
    writeln('Card deck: ', QuantityCards);
    gotoXY(100, 11);
    writeln('Players: ', QuantityPlayerInPlay);
    gotoXY(100, 13);
    writeln('You: ', Name);
    gotoXY(100, 14);
    writeln('Your Cash: ', Cash, '$');

    for j := 2 to QuantityPlayerInPlay do
      case j of
        2:
        begin
          gotoXY(55, 13);
          writeln('Petr');
          gotoXY(55, 14);
          for i := 1 to CombinationPlayer[2, 20] do
            Write(CombinationPlayer[2, i], ' ');

          CombinationPlayer[2, 19] := 0;
          for i := 1 to CombinationPlayer[2, 20] do
            CombinationPlayer[2, 19] :=
              CombinationPlayer[2, 19] + CombinationPlayer[2][i];
          gotoXY(61, 13);
          writeln('|', CombinationPlayer[2, 19], '|');
          if MakeBetSw = True then
          begin
            gotoXY(56, 16);
            Write(CombinationPlayer[2, 17], '$');
          end;
        end;
        3:
        begin
          gotoXY(40, 13);
          writeln('Max');
          gotoXY(40, 14);
          for i := 1 to CombinationPlayer[3, 20] do
            Write(CombinationPlayer[3, i], ' ');

          CombinationPlayer[3, 19] := 0;
          for i := 1 to CombinationPlayer[3, 20] do
            CombinationPlayer[3, 19] :=
              CombinationPlayer[3, 19] + CombinationPlayer[3][i];
          gotoXY(45, 13);
          writeln('|', CombinationPlayer[3, 19], '|');
          if MakeBetSw = True then
          begin
            gotoXY(41, 16);
            Write(CombinationPlayer[3, 17], '$');
          end;
        end;
        4:
        begin
          gotoXY(71, 13);
          writeln('Boy');
          gotoXY(71, 14);
          for i := 1 to CombinationPlayer[4, 20] do
            Write(CombinationPlayer[4, i], ' ');
          CombinationPlayer[4, 19] := 0;
          for i := 1 to CombinationPlayer[4, 20] do
            CombinationPlayer[4, 19] :=
              CombinationPlayer[4, 19] + CombinationPlayer[4][i];
          gotoXY(76, 13);
          writeln('|', CombinationPlayer[4, 19], '|');
          if MakeBetSw = True then
          begin
            gotoXY(72, 16);
            Write(CombinationPlayer[4, 17], '$');
          end;
        end;
      end;
    if WinSel = True then
    begin
      gotoXY(59, 17);
      Write('Win: ', Winner, ' !!!');
    end;
    gotoXY(39, 15);
    Write('-----------------------------------------');
    gotoXY(39, 19);
    Write('-----------------------------------------');
    gotoXY(55, 20);
    writeln(Name);
    gotoXY(55, 21);
    for i := 1 to CombinationPlayer[1, 20] do
      Write(CombinationPlayer[1, i], ' ');
    CombinationPlayer[1, 19] := 0;
    for i := 1 to CombinationPlayer[1, 20] do
      CombinationPlayer[1, 19] := CombinationPlayer[1, 19] + CombinationPlayer[1, i];
    gotoXY(length(Name) + 56, 20);
    writeln('|', CombinationPlayer[1, 19], '|');
    if MakeBetSw = True then
    begin
      gotoXY(57, 18);
      Write(CombinationPlayer[1, 17], '$');
    end;

    if MakeBetSw = True then
    begin
      gotoXY(84, 15);
      Write('  Bank');
      gotoXY(84, 16);
      Write('----------');
      gotoXY(84, 17);
      Write('   ', Bank, '$');
      gotoXY(84, 18);
      Write('----------');
    end;

    Hide;
  end;

  procedure MakeBet;
  var
    Player, Bet: integer;
  begin
    Bank := 0;
    MakeBetSw := True;
    CombinationPlayer[1, 17] := 0;
    while CombinationPlayer[1, 17] = 0 do
    begin
      gotoXY(59, 17);
      Write('Your Bet: ');
      gotoXY(59, 18);
      Readln(Bet);

      if Bet > CombinationPlayer[1, 18] then
      begin
        gotoXY(59, 18);
        Write('        ');
      end
      else
      begin
        CombinationPlayer[1, 17] := Bet;
        CombinationPlayer[1, 18] := CombinationPlayer[1, 18] - Bet;
        Cash := Cash - Bet;
        User[Position, 3] := IntToStr(Cash);
      end;
    end;

    for  Player := 2 to QuantityPlayerInPlay do
      case Player of
        2:
        begin
          CombinationPlayer[2, 17] += random(CombinationPlayer[2, 18]);
          CombinationPlayer[2, 18] :=
            CombinationPlayer[2, 18] - CombinationPlayer[2, 17];
        end;
        3:
        begin
          CombinationPlayer[3, 17] += random(CombinationPlayer[3, 18]);
          CombinationPlayer[3, 18] :=
            CombinationPlayer[3, 18] - CombinationPlayer[3, 17];
        end;
        4:
        begin
          CombinationPlayer[4, 17] += random(CombinationPlayer[4, 18]);
          CombinationPlayer[4, 18] :=
            CombinationPlayer[4, 18] - CombinationPlayer[4, 17];
        end;
      end;
    for i := 1 to QuantityPlayerInPlay do
      Bank += CombinationPlayer[i, 17];
    ReloadTable(QuantityCards, QuantityPlayerInPlay);
  end;

  procedure Win;
  var
    i, j, winpos, max: integer;
    PlayeNotLose: array [1..100, 1..2] of integer;
  begin
    j := 0;
    winpos := 0;

    for i := 1 to QuantityPlayerInPlay do
    begin
      if CombinationPlayer[i, 19] <= 21 then
      begin
        Inc(j);
        PlayeNotLose[j, 1] := CombinationPlayer[i, 19];
        PlayeNotLose[j, 2] := i;
      end;
    end;

    max := PlayeNotLose[1, 1];

    for i := 1 to j do
    begin
      if max < PlayeNotLose[i, 1] then
        max := PlayeNotLose[i, 1];
    end;

    for i := 1 to j do
    begin
      if max = PlayeNotLose[i, 1] then
        winpos := PlayeNotLose[i, 2];
    end;

    case winpos of
      0: Winner := 'NONE';
      1:
      begin
        Winner := Name;
        User[Position, 3] := IntToStr(StrToInt(User[Position, 3]) + Bank);
        Cash := StrToInt(User[Position, 3]);
      end;
      2:
      begin
        Winner := 'Petr';
        CombinationPlayer[2, 18] += Bank;
      end;
      3:
      begin
        Winner := 'Max';
        CombinationPlayer[3, 18] += Bank;
      end;
      4:
      begin
        Winner := 'Boy';
        CombinationPlayer[4, 18] += Bank;
      end;
    end;
    WinSel := True;
    HideMode := False;
    ExportDataStats;
    ReloadTable(QuantityCards, QuantityPlayerInPlay);
  end;

  procedure TakeCardBots;
  var
    Chance, Player: integer;
  begin
    for Player := 1 to QuantityPlayerInPlay do
    begin
      case Player of
        2:
        begin
          if CombinationPlayer[2, 19] <= 10 then
          begin
            Inc(CombinationPlayer[2, 20]);
            CombinationPlayer[2, CombinationPlayer[2, 20]] := CombinationCard(1);
          end
          else if (CombinationPlayer[2, 19] > 10) and
            (CombinationPlayer[2, 19] <= 15) then
          begin
            Chance := random(2);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[2, 20]);
              CombinationPlayer[2, CombinationPlayer[2, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[2, 19] > 15) and
            (CombinationPlayer[2, 19] <= 19) then
          begin
            Chance := random(11);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[2, 20]);
              CombinationPlayer[2, CombinationPlayer[2, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[2, 19] >= 20) and
            (CombinationPlayer[2, 19] <= 21) then
          begin
            Chance := random(51);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[2, 20]);
              CombinationPlayer[2, CombinationPlayer[2, 20]] := CombinationCard(1);
            end;
          end;
        end;
        3:
        begin
          if CombinationPlayer[3, 19] <= 10 then
          begin
            Inc(CombinationPlayer[3, 20]);
            CombinationPlayer[3, CombinationPlayer[3, 20]] := CombinationCard(1);
          end
          else if (CombinationPlayer[3, 19] > 10) and
            (CombinationPlayer[3, 19] <= 15) then
          begin
            Chance := random(2);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[3, 20]);
              CombinationPlayer[3, CombinationPlayer[3, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[3, 19] > 15) and
            (CombinationPlayer[3, 19] <= 18) then
          begin
            Chance := random(11);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[3, 20]);
              CombinationPlayer[3, CombinationPlayer[3, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[3, 19] >= 19) and
            (CombinationPlayer[3, 19] <= 21) then
          begin
            Chance := random(51);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[3, 20]);
              CombinationPlayer[3, CombinationPlayer[3, 20]] := CombinationCard(1);
            end;
          end;
        end;
        4:
        begin
          if CombinationPlayer[4, 19] <= 10 then
          begin
            Inc(CombinationPlayer[4, 20]);
            CombinationPlayer[4, CombinationPlayer[4, 20]] := CombinationCard(1);
          end
          else if (CombinationPlayer[4, 19] > 10) and
            (CombinationPlayer[4, 19] <= 15) then
          begin
            Chance := random(2);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[4, 20]);
              CombinationPlayer[4, CombinationPlayer[4, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[4, 19] > 15) and
            (CombinationPlayer[4, 19] <= 19) then
          begin
            Chance := random(11);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[4, 20]);
              CombinationPlayer[4, CombinationPlayer[4, 20]] := CombinationCard(1);
            end;
          end
          else if (CombinationPlayer[4, 19] >= 20) and
            (CombinationPlayer[4, 19] <= 21) then
          begin
            Chance := random(51);
            if Chance = 0 then
            begin
              Inc(CombinationPlayer[4, 20]);
              CombinationPlayer[4, CombinationPlayer[4, 20]] := CombinationCard(1);
            end;
          end;
        end;
      end;
    end;
    ReloadTable(QuantityCards, QuantityPlayerInPlay);
  end;

  procedure CheckLoos;
  begin
    if CombinationPlayer[1, 19] > 21 then
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
    ForbiddenCardNum := 0;
    QuantityCards := 52;
    NewGameBool := True;
    WinSel := False;
    HideMode := True;
    MakeBetSw := False;

    for i := 2 to 10 do
      for j := 1 to 4 do
        Card[i, j] := i;
    for i := 11 to 13 do
      for j := 1 to 4 do
        Card[i, j] := 10;

    for i := 1 to 100 do
      for j := 1 to 18 do
        CombinationPlayer[i, j] := 0;

    for i := 1 to 100 do
      CombinationPlayer[i, 20] := 2;


    for i := 2 to 100 do
      CombinationPlayer[i, 17] := 0;

    for i := 1 to 100 do
      ForbiddenCard[i] := '';
  end;



  procedure NewGame;//Start new game
  var
    i, j: integer;
    AlvaysPlay: boolean;
  begin
    ClearScreen;
    BJLabel;
    AlvaysPlay := True;

    if NewGameBool = True then
    begin
      for j := 1 to QuantityPlayerInPlay do
      begin
        CombinationPlayer[j, 1] := CombinationCard(1);
        CombinationPlayer[j, 2] := CombinationCard(1);
        CombinationPlayer[j, 18] := 100;
      end;

      CombinationPlayer[1, 18] := Cash;

      for i := 1 to length(Loading) do
      begin
        Delay(500);
        GotoXY(20, 55 + i);
        Write(Loading[i]);
      end;
      ReloadTable(QuantityCards, QuantityPlayerInPlay);
    end;

    NewGameBool := False;
    while AlvaysPlay = True do
    begin

      if WinSel = True then
      begin
        gotoXY(3, 25);
        writeln('1. NEW GAME');
        gotoXY(3, 26);
        writeln('2. EXIT TO Menu');
        gotoXY(3, 28);
        Write('Select: ');
        gotoXY(12, 28);
        readln(i);
        case i of
          1:
          begin
            AlvaysPlay := False;
            ArrCards;
            NewGame;
          end;
          2:
          begin
            ExportDataStats;
            MenuError := False;
            NewGameError := True;
            AlvaysPlay := False;
          end;
        end;
      end
      else
      begin
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
        readln(i);
        case i of
          1:
          begin
            Inc(CombinationPlayer[1, 20]);
            CombinationPlayer[1, CombinationPlayer[1, 20]] := CombinationCard(1);
            ReloadTable(QuantityCards, QuantityPlayerInPlay);
            CheckLoos;
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
            MenuError := False;
            NewGameError := True;
            AlvaysPlay := False;
          end;
        end;
      end;
    end;
  end;

  procedure StartGame;//Start new game
  var
    Start: string;
  begin
    ClearScreen;
    BJLabel;
    Write('Number of players "2-4" : ');
    readln(QuantityPlayerInPlay);
    Write('!=START ENTER=!');
    readln(Start);
    NewGame;
  end;

  procedure Stats;//Stats User
  var
    i: integer;
    stop: string;
  begin
    ClearScreen;
    BJLabel;
    stop := '';
    for i := 1 to NumberPlayers do
    begin
      Writeln(User[i, 1], ': ', User[i, 3], '$');
    end;

  end;

  procedure MenuModSwicher;//Mod Swicher
  begin
    case MenuMod of
      1: MenuError := True;
      2: Stats;
      3:
      begin
        MS := True;
        MenuError := True;
        ExportDataStats;
      end;
      4: Exit;
    end;
  end;


  procedure MenuGame;//Menu screen
  begin
    BJLabel;
    gotoxy(28, 8);
    if Position = 101 then
      Cash := 10000000
    else
      Cash := StrToInt(User[Position, 3]);
    Writeln('Accaunt: ', Name, ' |Cash: ', Cash, '$');
    Writeln('Menu');
    Writeln('1. New Game');
    Writeln('2. Stats');
    Writeln('3. LogOut');
    Write('Select Mode: ');
    Read(MenuMod);
    MenuModSwicher;
  end;

  procedure Register;//Register User
  begin
    Inc(NumberPlayers);
    User[NumberPlayers, 1] := '';
    User[NumberPlayers, 2] := '';
    Write('Login: ');
    Readln(User[NumberPlayers, 1]);
    Write('Pass: ');
    Readln(User[NumberPlayers, 2]);
    User[NumberPlayers, 3] := '100';
    Name := User[NumberPlayers, 1];
    Position := NumberPlayers;
    ExportDataStats;
    LoginError := True;
  end;


  procedure Login;//Login User
  var
    P: string;
    i: integer;
    E: boolean;
  begin
    P := '';
    Name := '';
    E := True;
    Write('UName: ');
    Readln(Name);
    for i := 1 to NumberPlayers do
    begin
      if User[i, 1] = Name then
      begin
        Write('UPass: ');
        Readln(P);
        if P = User[i, 2] then
        begin
          Position := i;
          LoginError := True;
          E := False;
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
      if (i = NumberPlayers) and (User[i, 1] <> Name) and (E <> False) then
      begin
        Writeln('Wrong login!');
        Delay(1000);
      end;
    end;
  end;

  procedure LoginModSwicher;//Login Mod Swicher
  begin
    case LoginMod of
      1: Login;
      2: Register;
      667487:
      begin
        Name := 'Admin';
        Position := 101;
        LoginError := True;
      end;
    end;
  end;

  procedure LoginAccaunt;//Login Screen
  begin
    BJLabel;
    Writeln('1. Login');
    Writeln('2. Register');
    Write('Select Mode: ');
    Readln(LoginMod);
    LoginModSwicher;
  end;

begin
  LoadingWindow; //Loading Screen Window
  ClearScreen;//Clear Screen
  LoadDataStats;//Load Bas
  LoginGo:
    MenuMod := 0;
  LoginMod := 0;
  for i := 2 to 100 do
    CombinationPlayer[i, 18] := 100;
  LoginError := False;
  MenuError := False;

  MS := False;
  while LoginError <> True do
  begin
    LoginAccaunt;
  end;

  MenuGo:
    NewGameError := False;

  while MenuError <> True do
  begin
    MenuGame;
  end;
  if MS = True then
    goto LoginGo;

  ArrCards;

  while NewGameError <> True do
  begin
    StartGame;
  end;
  ExportDataStats;
  goto MenuGo;
  ExportDataStats;
end.
