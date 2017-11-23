{$CODEPAGE CP866}
{$mode objfpc}
{$H+}
{$codepage UTF8}
program BJW;

uses
  CRT;

const
  Loading = '. . .';

type
  UserDataList = record
    Name: string[100];
    Pass: string[100];
    Point: integer;
  end;

var
  i, j, MenuMod, LoginMod: integer;
  Start, Name, Pass: string;
  User: array[1..100] of UserDataList;
  NumberPlayers: integer;
  T: file of UserDataList;
  T1: text;

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
  Read(Start);
end;


procedure ClearScreen;//Clear Screen
begin
  ClrScr;
end;

procedure LoadDataStats;//Load GameStats
var
  i: integer;
  N, Pa, Po: UserDataList;
begin
  Assign(T, 'DataStatistic.txt');
  Assign(T1, 'DataStatisticPlayer.txt');
  Reset(T);
  Reset(T1);
  Read(T1, NumberPlayers);
  for i := 1 to NumberPlayers do
  begin
    Read(T, N, Pa, Po);
    User[i].Name := N.Name;
    User[i].Pass := Pa.Pass;
    User[i].Point := Po.Point;
  end;
  Close(T);
  Close(T1);
end;

procedure ExportDataStats;//Export GameStats
var
  i: integer;
  N, Pa, Po: UserDataList;
begin
  Assign(T, 'DataStatistic.txt');
  Assign(T1, 'DataStatisticPlayer.txt');
  Rewrite(T);
  Rewrite(T1);
  Write(T1, NumberPlayers);
  for i := 1 to NumberPlayers do
  begin
    N.Name := User[i].Name;
    Pa.Pass := User[i].Pass;
    Po.Point := User[i].Point;
    write(T, N, Pa, Po);
  end;
  Close(T);
  Close(T1);
end;

procedure NewGame;//Start new game
begin
  BJLabel;
end;


procedure MenuGame;//Menu screen
begin
  BJLabel;
  gotoxy(24, 8);
  Writeln('Menu');
  Writeln('1. New Game');
  Writeln('2. Stats');
  Write('Select Mode: ');
  Read(MenuMod);
end;

procedure Stats;//Stats User
var
  i: integer;
  Stop:string;
begin
  ClearScreen;
  BJLabel;
  for i := 1 to NumberPlayers do
  begin
    Writeln(User[i].Name, ': ', User[i].Point);
  end;
  delay(1000);
  MenuGame;
end;

procedure MenuModSwicher;//Mod Swicher
begin
  case MenuMod of
    // 1:
    2: Stats;
  end;
end;

procedure Register;//Register User
//var
 // Name, Pass: string;
begin
  inc(NumberPlayers);
  Write('Login: ');
  Read(Name);
  User[NumberPlayers].Name := Name;
  Write('Pass: ');
  Read(Pass);
  User[NumberPlayers].Pass := Pass;
  MenuGame;
end;


procedure Login;//Login User
var
  // N, P: string;
  i: integer;
begin
  write('UName: ');
  read(Name);
  for i := 1 to NumberPlayers do
  begin
    if User[i].Name = Name then
    begin
      Write('UPass: ');
      read(Pass);
      if Pass = User[i].Pass then
      begin
        break;
        MenuGame;
      end
      else
      begin
        Write('Wrong password!');
        Delay(200);
        Login;
      end;
    end
    else
    begin
      Write('Wrong Login!');
      Delay(200);
      Login;
    end;
  end;
end;

procedure LoginModSwicher;//Login Mod Swicher
begin
  case LoginMod of
    1: Login;
    2: Register;
  end;
end;

procedure LoginAccaunt;//Login Screen
begin
  BJLabel;
  Writeln('1. Login');
  Writeln('2. Register');
  read(LoginMod);
  LoginModSwicher;
end;

begin
  // LoadingWindow; //Loading Screen Window
  ClearScreen;//Clear Screen
  LoadDataStats;//Load Bas
  //LoginAccaunt;
  MenuGame;//Menu screen
  MenuModSwicher;
  ExportDataStats;
end.
