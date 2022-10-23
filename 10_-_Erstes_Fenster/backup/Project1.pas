program Project1;

uses
  unixtype,
  ctypes,
  xlib,
  xutil,
  keysym,
  x;

var
  dis: PDisplay;
  win: TWindow;
  Event: TXEvent;
  scr: cint;

begin
  // Erstellt die Verbindung zum Server
  dis := XOpenDisplay(nil);
  if dis = nil then begin
    WriteLn('Kann nicht das Display öffnen');
    Halt(1);
  end;
  scr := DefaultScreen(dis);

  // Erstellt das Fenster
  win := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 320, 240, 1000, BlackPixel(dis, scr), WhitePixel(dis, scr));

  // Wählt die gewünschten Ereignisse aus
  // Es wird nur das Tastendrückereigniss <b>KeyPressMask</b> gebraucht.
  XSelectInput(dis, win, KeyPressMask);

  // Fenster anzeigen
  XMapWindow(dis, win);

  // Ereignisschleife
  while (True) do begin
    XNextEvent(dis, @Event);

    case Event._type of
      KeyPress: begin
        // Beendet das Programm bei [ESC]
        if XLookupKeysym(@Event.xkey, 0) = XK_Escape then begin
          Break;
        end;
      end;
    end;

  end;

  // Schliesst Verbindung zum Server
  XCloseDisplay(dis);
end.
