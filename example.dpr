{*******************************************************************************
 Project   : Timers
 Date      : 13-08-2008
 Version   : 1.0
 Author    : Maks1509
 URL       : www.maks1509.webhost.ru
 Copyright : Copyright (c) 2008 Maks1509
*******************************************************************************}

program example;

uses
 Windows, Messages;

{$R example.res}

const
  RC_DIALOG      = 101;
  ID_EDIT_PLAY   = 101;
  ID_BTN_PLSTART = 102;
  ID_BTN_PLSTOP  = 103;
  ID_EDIT_REC    = 104;
  ID_BTN_RCSTART = 105;
  ID_BTN_RCSTOP  = 106;
  TIMER_PLAY     = 110;
  TIMER_REC      = 111;

var
  TickDifPlay   : DWORD;
  TickDifRec    : DWORD;
  TickStartPlay : DWORD;
  TickStartRec  : DWORD;
  hApp          : Integer;

{ Преобразование типа String в тип Integer }

function IntToStr(I : Int64) : String;
begin
  Str(I, Result);
end;

{ Форматирование строки для удобного отображения времени }

function FormatTime(T : Cardinal) : String;
begin
  T := T div 1000;
  Result := IntToStr(T mod 60);
  case T mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
  T := T div 60;
  Result := IntToStr(T mod 60) + ':' + Result;
  case T mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
  T := T div 60;
  Result := IntToStr(T mod 24) + ':' + Result;
  case t mod 60 < 10 of
    TRUE : Result := '0' + Result;
  end;
end;

{ Запуск первого таймера }

function StartTimerPlay() : Boolean;
begin
  TickDifPlay := GetTickCount - TickStartPlay;
  SendMessage(GetDlgItem(hApp, ID_EDIT_PLAY), WM_SETTEXT, 0, Integer(PChar(FormatTime(TickDifPlay))));
  Result := TRUE;
end;

{ Запуск второго таймера }

function StartTimerRec() : Boolean;
begin
  TickDifRec := GetTickCount - TickStartRec;
  SendMessage(GetDlgItem(hApp, ID_EDIT_REC), WM_SETTEXT, 0, Integer(PChar(FormatTime(TickDifRec))));
  Result := TRUE;
end;

{ Обработка сообщений диалогового окна }

function MainDlgProc(hWnd : THandle; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOL; stdcall;
begin
  Result := FALSE;
  case uMsg of
    WM_INITDIALOG : hApp := hWnd;
    WM_COMMAND :
      begin
        case LoWord(wParam) of
          ID_BTN_PLSTART :
            begin
              TickStartPlay := GetTickCount;
              SetTimer(hApp, TIMER_PLAY, 1000, @StartTimerPlay);
              SendMessage(GetDlgItem(hApp, ID_EDIT_PLAY), WM_SETTEXT, 0, Integer(PChar(FormatTime(0))));
            end;
          ID_BTN_PLSTOP : KillTimer(hApp, TIMER_PLAY);
          ID_BTN_RCSTART :
            begin
              TickStartRec := GetTickCount;
              SetTimer(hApp, TIMER_REC, 1000, @StartTimerRec);
              SendMessage(GetDlgItem(hApp, ID_EDIT_REC), WM_SETTEXT, 0, Integer(PChar(FormatTime(0))));
            end;
          ID_BTN_RCSTOP : KillTimer(hApp, TIMER_REC);
        end;
      end;
    WM_DESTROY, WM_CLOSE :
      begin
        KillTimer(hApp, TIMER_PLAY);
        KillTimer(hApp, TIMER_REC);
        PostQuitMessage(0);
      end;
  end;
end;

begin
  DialogBox(hInstance, MAKEINTRESOURCE(RC_DIALOG), 0, @MainDlgProc);
end.
