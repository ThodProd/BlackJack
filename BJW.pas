{$CODEPAGE CP866}
{$mode objfpc}
{$H+}
{$codepage UTF8}
program BJW;

uses
 LCLProc;

const
  Loading = '. . .';

  procedure LoadingWindow;//Home screen setup
  var
    i: integer;
  begin
    textbackground(Green);
    clrscr;
    Writeln(UTF8ToConsole('██████████████████████████████████████████████████████'));
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
  end;

var
  i, j: integer;
begin

  LoadingWindow; //Load Screen Window
  Read(j);
end.
