program Day06;
{$mode objfpc}
uses
  Classes, SysUtils;

procedure countAny(fn : String);
var
  slInfo: TStringList;
  line: String;
  line_len: integer;
  charset: set of char;
  total_group_count: integer;
  c : char;

Begin
  // Create an instance of the string list to handle the textfile
  slInfo := TStringList.Create;
  total_group_count := 0;

  // Embed the file handling in a try/except block to handle errors gracefully
  try
    // Load the contents of the textfile completely in memory
    slInfo.LoadFromFile(fn);
  except
    // If there was an error the reason can be found here
    on E: EInOutError do
      writeln('File handling error occurred. Reason: ', E.Message);
  end;

  charset := [];

  for line in slInfo do
  begin
    line_len := byte(line[0]);
    if line_len = 0 then
    begin
      for c in charset do
        total_group_count := total_group_count + 1;
      // writeln('Group Count: ', total_group_count);
      charset := [];
    end
    else
    begin
      for c in line do
        Include(charset, c);
    end;
  end;
    for c in charset do
      total_group_count := total_group_count + 1;
    writeln('Any Yes Count of file ', fn, ': ', total_group_count);
End;

procedure countAll(fn : String);
var
  slInfo: TStringList;
  line: String;
  line_len: integer;
  c : char;

  set_of_all_yes: set of char;
  current_char_set: set of char;
  all_yes_count: integer;
  current_group_all_yes_count: integer;
  is_start_of_group : boolean;

Begin
  // Create an instance of the string list to handle the textfile
  slInfo := TStringList.Create;

  // Embed the file handling in a try/except block to handle errors gracefully
  try
    // Load the contents of the textfile completely in memory
    slInfo.LoadFromFile(fn);
  except
    // If there was an error the reason can be found here
    on E: EInOutError do
      writeln('File handling error occurred. Reason: ', E.Message);
  end;

  set_of_all_yes := [];
  all_yes_count := 0;
  is_start_of_group := true;

  for line in slInfo do
  begin
    line_len := byte(line[0]);
    if line_len = 0 then
    begin
      current_group_all_yes_count := 0;
      for c in set_of_all_yes do
      begin
        current_group_all_yes_count := current_group_all_yes_count + 1;
      end;
      set_of_all_yes := [];
      is_start_of_group := true;
      //writeln('current group all yes count: ', current_group_all_yes_count);
      all_yes_count := all_yes_count + current_group_all_yes_count;
    end
    else
    begin
      current_char_set := [];
      for c in line do
      begin
        Include(current_char_set, c);
      end;

      if is_start_of_group then
      begin
        set_of_all_yes := current_char_set;
      end
      else
      begin
        set_of_all_yes := set_of_all_yes * current_char_set;
      end;
      is_start_of_group := false;
    end;
  end;

  current_group_all_yes_count := 0;
  for c in set_of_all_yes do
  begin
    current_group_all_yes_count := current_group_all_yes_count + 1;
  end;
  //writeln('final group all yes count: ', current_group_all_yes_count);
  all_yes_count := all_yes_count + current_group_all_yes_count;
  writeln('All yes count of file ', fn, ': ', all_yes_count);
End;


begin
countAny('demo.txt');
countAny('data.txt');
countAll('demo.txt');
countAll('data.txt');
end.