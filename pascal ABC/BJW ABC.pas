{$CODEPAGE CP866}
{$mode objfpc}
{$H+}
{$codepage UTF8}
program BJW;

uses
  CRT;

const
  Loading = '. . .';

var
  i, j, MenuMod: integer;
  Start: string;

procedure LoadingWindow;//Home screen setup
var
  i: integer;
begin
  textbackground(Green);
  clrscr;
  Writeln('██████████████████████████████████████████████████████');
  Writeln('█────███─████────██────██─██─████──██────██────██─██─█');
  Writeln('█─██──██─████─██─██─██─██─█─██████─██─██─██─██─██─█─██');
  Writeln('█────███─████────██─█████──███████─██────██─█████──███');
  Writeln('█─██──██─████─██─██─██─██─█─███─██─██─██─██─██─██─█─██');
  Writeln('█────███───██─██─██────██─██─██────██─██─██────██─██─█');
  Writeln('██████████████████████████████████████████████████████');
  
  
  gotoxy(40, 10);
  Write('Loading ');
  for i := 1 to length(Loading) do
  begin
    Delay(200);
    Write(Loading[i]);
    Delay(200);
  end;
  gotoxy(40, 15);
  Writeln('Enter to start');
  Read(Start);
end;

procedure MenuGame;//Menu screen
begin
  textbackground(Green);
  ClrScr;
  Writeln('██████████████████████████████████████████████████████');
  Writeln('█────███─████────██────██─██─████──██────██────██─██─█');
  Writeln('█─██──██─████─██─██─██─██─█─██████─██─██─██─██─██─█─██');
  Writeln('█────███─████────██─█████──███████─██────██─█████──███');
  Writeln('█─██──██─████─██─██─██─██─█─███─██─██─██─██─██─██─█─██');
  Writeln('█────███───██─██─██────██─██─██────██─██─██────██─██─█');
  Writeln('██████████████████████████████████████████████████████');
  
  
  gotoxy(24, 8);
  Writeln('Menu');
  Writeln('1. New Game');
  Writeln('2. Load');
  Writeln('3. Stats');
  Writeln('4. Exit');
  Write('Select Mode: ');
  Read(MenuMod);
end;

procedure ClearScreen;//Clear Screen
begin
  ClrScr;
end;

procedure MenuModSwicher;//Clear Screen
begin
  case MenuMod of
  //1:
  //2:
 // 3:
  //4: 
  end;
end;

begin
  
  //LoadingWindow; //Load Screen Window
  
  //ClearScreen;//Clear Screen
  MenuGame;//Menu screen
  MenuModSwicher;
end.