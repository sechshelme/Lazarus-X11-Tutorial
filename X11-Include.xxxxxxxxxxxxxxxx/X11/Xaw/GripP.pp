
unit GripP;
interface

{
  Automatically converted by H2Pas 1.0.0 from /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/GripP.h
  The following command line parameters were used:
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/GripP.h
    -p
    -T
    -S
    -d
    -c
    -o
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/GripP.pp
}

{ Pointers to basic pascal types, inserted by h2pas conversion program.}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;

Type
PGripClassPart  = ^GripClassPart;
PGripClassRec  = ^GripClassRec;
PGripPart  = ^GripPart;
PGripRec  = ^GripRec;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}



{$ifndef _XawGripP_h}
{$define _XawGripP_h}
{$include <X11/Xaw/Grip.h>}
{$include <X11/Xaw/SimpleP.h>}

const
  DEFAULT_GRIP_SIZE = 8;  

type
  PGripClassPart = ^TGripClassPart;
  TGripClassPart = record
      extension : TXtPointer;
    end;


  PGripClassRec = ^TGripClassRec;
  TGripClassRec = record
      core_class : TCoreClassPart;
      simple_class : TSimpleClassPart;
      grip_class : TGripClassPart;
    end;
  var
    gripClassRec : TGripClassRec;cvar;external;

{$ifndef OLDXAW}

{$endif}
type
  PGripPart = ^TGripPart;
  TGripPart = record
      grip_action : TXtCallbackList;
      pad : array[0..3] of TXtPointer;
    end;


  PGripRec = ^TGripRec;
  TGripRec = record
      core : TCorePart;
      simple : TSimplePart;
      grip : TGripPart;
    end;
{$endif}


implementation


end.
