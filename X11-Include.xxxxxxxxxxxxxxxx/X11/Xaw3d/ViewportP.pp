
unit ViewportP;
interface

{
  Automatically converted by H2Pas 1.0.0 from /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw3d/ViewportP.h
  The following command line parameters were used:
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw3d/ViewportP.h
    -p
    -T
    -S
    -d
    -c
    -o
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw3d/ViewportP.pp
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
PViewportClassPart  = ^ViewportClassPart;
PViewportClassRec  = ^ViewportClassRec;
PViewportConstraints  = ^ViewportConstraints;
PViewportConstraintsPart  = ^ViewportConstraintsPart;
PViewportConstraintsRec  = ^ViewportConstraintsRec;
PViewportPart  = ^ViewportPart;
PViewportRec  = ^ViewportRec;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}




{$ifndef _ViewportP_h}
{$define _ViewportP_h}
{$include <X11/Xaw3d/Viewport.h>}
{$include <X11/Xaw3d/FormP.h>}
{$include <X11/Xaw3d/ThreeDP.h>}
type
  PViewportClassPart = ^TViewportClassPart;
  TViewportClassPart = record
      empty : longint;
    end;

  PViewportClassRec = ^TViewportClassRec;
  TViewportClassRec = record
      core_class : TCoreClassPart;
      composite_class : TCompositeClassPart;
      constraint_class : TConstraintClassPart;
      form_class : TFormClassPart;
      viewport_class : TViewportClassPart;
    end;
  var
    viewportClassRec : TViewportClassRec;cvar;external;











type
  PViewportPart = ^TViewportPart;
  TViewportPart = record
      forcebars : TBoolean;
      allowhoriz : TBoolean;
      allowvert : TBoolean;
      usebottom : TBoolean;
      useright : TBoolean;
      report_callbacks : TXtCallbackList;
      clip : TWidget;
      child : TWidget;
      horiz_bar : TWidget;
      vert_bar : TWidget;
      threeD : TThreeDWidget;
    end;

  PViewportRec = ^TViewportRec;
  TViewportRec = record
      core : TCorePart;
      composite : TCompositePart;
      constraint : TConstraintPart;
      form : TFormPart;
      viewport : TViewportPart;
    end;




  PViewportConstraintsPart = ^TViewportConstraintsPart;
  TViewportConstraintsPart = record
      reparented : TBoolean;
    end;

  PViewportConstraintsRec = ^TViewportConstraintsRec;
  TViewportConstraintsRec = record
      form : TFormConstraintsPart;
      viewport : TViewportConstraintsPart;
    end;
  TViewportConstraints = PViewportConstraintsRec;
  PViewportConstraints = ^TViewportConstraints;
{$endif}


implementation


end.
