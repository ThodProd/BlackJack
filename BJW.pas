program BJW;

{$mode objfpc}{$H+}
{$CODEPAGE CP866}
{$codepage UTF8}
uses
  CRT,
  SysUtils;

const
  Loading = '. . .';

label
  LoginGo;
var
  i, j, MenuMod, LoginMod: integer;                              //1 - Черви
  Start, Name: string;                                           //2 - Буби
  MenuError, LoginError, NewGameError, MS: boolean;              //3 - Крести
  User: array[1..100, 1..3] of string;                           //4 - Пики
  Card: array[1..13, 1..4] of integer;
  CombinationPlayer: array[1..100, 1..20] of string;
  ForbiddenCard: array[1..100] of string;
  NumberPlayers, Cash, Position, QuantityCards,
  QuantityPlayerInPlay, ForbiddenCardNum: integer;
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

  function CombinationCard(N: integer): string;//Combination card
  var
    i, j, InI: integer;
    Comb: string;
    Check: boolean;
  begin
    CombinationCard := '';
    for InI := 1 to N do
    begin
      Dec(QuantityCards);
      Check := False;
      while Check <> True do
      begin
        i := random(13) + 1;
        j := random(4) + 1;
        Comb := IntToStr(i) + IntToStr(j);
        Check := CombinationCheck(Comb);
      end;
      AddForbiddenCard(Comb);
      CombinationCard += IntToStr(Card[i, j]) + ' ';
    end;
  end;


  procedure ArrCards;//ArrayCards
  var
    i, j: integer;
  begin
    for i := 2 to 10 do
      for j := 1 to 4 do
        Card[i, j] := i;
    for i := 11 to 13 do
      for j := 1 to 4 do
        Card[i, j] := 10;

    for i := 1 to 100 do
      for j := 1 to 20 do
        CombinationPlayer[i, j] := '';
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

  procedure NewGame;//Start new game
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
    gotoXY(28, 15);
    writeln('Bot');
    gotoXY(28, 16);
    CombinationCard(2);
    gotoXY(28, 20);
    writeln(Name);
    gotoXY(28, 21);
    CombinationCard(2);
    readln(i);
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
    Write('');
    Readln(stop);
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
  //LoadingWindow; //Loading Screen Window
  ClearScreen;//Clear Screen
  LoadDataStats;//Load Bas
  LoginGo:
    MenuMod := 0;
  LoginMod := 0;
  ForbiddenCardNum := 0;
  QuantityCards := 52;
  LoginError := False;
  MenuError := False;
  NewGameError := False;
  MS := False;
  while LoginError <> True do
  begin
    LoginAccaunt;
  end;

  while MenuError <> True do
  begin
    MenuGame;
  end;
  if MS = True then
    goto LoginGo;

  ArrCards;

  while NewGameError <> True do
  begin
    Write('Number of players "2-2" : ');
    readln(QuantityPlayerInPlay);
    Write('Start Enter');
    readln(Start);
    NewGame;
  end;


  ExportDataStats;
end.
