//image image.png
(*
Erstes Fenster mit <b>X11</b> wird erstellt.
Es wird nur ein einziges Eregniss gebraucht.
Ein Tastatur-Event, welches <b>[ESC]</b> abfängt und das Programm beendet.
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

var
  dis: PDisplay;
  win1,win2 :TWindow;
  Event: TXEvent;
  scr: cint;
  gc: TGC;
  i: Integer;

begin
  // Erstellt die Verbindung zum Server
  dis := XOpenDisplay(nil);
  if dis = nil then begin
    WriteLn('Kann nicht das Display öffnen');
    Halt(1);
  end;
  scr := DefaultScreen(dis);
  gc := DefaultGC(dis, scr);



  // Erstellt das Fenster
  win1 := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 320, 240, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));
//  win2 := XCreateSimpleWindow(dis, RootWindow(dis, scr), 10, 10, 320, 240, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));
  win2 := XCreateSimpleWindow(dis, win1, 100, 100, 320, 240, 1, BlackPixel(dis, scr), WhitePixel(dis, scr));

  // Wählt die gewünschten Ereignisse aus
  // Es wird nur das Tastendrückereigniss <b>KeyPressMask</b> gebraucht.
  XSelectInput(dis, win1, KeyPressMask or ExposureMask);
  XSelectInput(dis, win2, KeyPressMask or ExposureMask);

  // Fenster anzeigen
  XMapWindow(dis, win1);
  XMapWindow(dis, win2);

  // Ereignisschleife
  while (True) do begin
    XNextEvent(dis, @Event);

    case Event._type of
      Expose:begin
        XClearWindow(dis, win1);
        XClearWindow(dis, win2);
        for i := 0 to 1000 do begin
          XSetForeground(dis, gc, Random($FF));
          XDrawArc(dis, win1, gc, random(500) - 200, random(500) - 200, 150, 150, 0, 360 * 64);

          XSetForeground(dis, gc, Random($FF)shl 8);
          XDrawArc(dis, win2, gc, random(500) - 200, random(500) - 200, 150, 150, 0, 360 * 64);
        end;
        end;
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
//code-
