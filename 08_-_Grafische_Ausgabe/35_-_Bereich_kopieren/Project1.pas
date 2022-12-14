//image image.png
(*
Einfache rechteckige Regionen
Dabei ist es möglich durch mehrmaliges generieren von Rechteckregionen, das sie sich addieren.
*)
//lineal
//code+
program Project1;

uses
  unixtype,
  ctypes,
  xlib,
  xutil,
  keysym,
  x;

type
  TMyWin = class(TObject)
  private
    dis: PDisplay;
    scr: cint;
    win: TWindow;
    gc: TGC;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

  constructor TMyWin.Create;
  begin
    inherited Create;

    // Erstellt die Verbindung zum Server
    dis := XOpenDisplay(nil);
    if dis = nil then begin
      WriteLn('Kann nicht das Display öffnen');
      Halt(1);
    end;
    scr := DefaultScreen(dis);
    gc := DefaultGC(dis, scr);

    // Erstellt das Fenster
    win := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 320, 240, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));

    // Wählt die gewünschten Ereignisse aus
    // Es werden die Ereignisse <b>KeyPressMask</b> und <b>ExposureMask</b> für die grafische Auzsgabe gebraucht.
    XSelectInput(dis, win, KeyPressMask or ExposureMask);

    // Fenster anzeigen
    XMapWindow(dis, win);
    XSetLineAttributes(dis, gc, 5, LineSolid, CapNotLast, JoinBevel);
  end;

  destructor TMyWin.Destroy;
  begin
    // Schliesst das Fenster
    XDestroyWindow(dis, win);

    // Schliesst Verbindung zum Server
    XCloseDisplay(dis);
    inherited Destroy;
  end;

  procedure TMyWin.Run;
  var
    Event: TXEvent;
    i: integer;

    function Rect(Left, Top, Width, Height: cshort): TXRectangle;
    begin
      Result.x := Left;
      Result.y := Top;
      Result.Width := Width;
      Result.Height := Height;
    end;

  begin
    // Ereignisschleife
    while (True) do begin
      XNextEvent(dis, @Event);

      case Event._type of
        Expose: begin
          XClearWindow(dis, win);

          // Kreise zeichnen
          for i := 0 to 20 do begin
            XSetForeground(dis, gc, Random($FFFFFF));
            XDrawArc(dis, win, gc, random(500) - 200, random(500) - 200, 150, 150, 0, 360 * 64);

            XSetForeground(dis, gc, $000000);
            XDrawRectangle(dis, win, gc, 10, 10, 100, 100);
            XDrawRectangle(dis, win, gc, 150, 10, 100, 100);
          end;

          // Bereich kopieren
          XCopyArea(dis, win, win, gc, 10, 10, 100, 100, 150, 10);

          // Nur Monocrom
          XCopyPlane(dis, win, win, gc, 10, 10, 100, 100, 10, 150, 1);
        end;
        KeyPress: begin
          // Beendet das Programm bei [ESC]
          if XLookupKeysym(@Event.xkey, 0) = XK_Escape then begin
            Break;
          end;
        end;
      end;

    end;
  end;

var
  MyWindows: TMyWin;

begin
  MyWindows := TMyWin.Create;
  MyWindows.Run;
  MyWindows.Free;
end.
//code-
