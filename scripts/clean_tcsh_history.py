#!/bin/env python3
from dataclasses import dataclass
from itertools import filterfalse
from pathlib import Path

@dataclass
class HistEntry():
  timestamp : int = 0
  command   : str = ""




def parse_history(histfile):
  entries = []
  with open(histfile,"r") as fp:
    timestamp = 0
    command   = ""

    for i,line in enumerate(fp):
      if(i%2==0):
        timestamp = line
        timestamp = int(timestamp[2:])
      else      :
        command = line.rstrip("\n")
        entry = HistEntry(timestamp, command)
        entries.append(entry)

  return entries

def save_history(histfile, histcount, entries):
  print(histfile, histcount, len(entries))
  if( histcount ): entries = entries[-histcount:]
  with open(histfile,"w") as fp:
    for entry in entries:
      fp.write(f"#+{entry.timestamp:0d}\n")
      fp.write(f"{entry.command}\n")


def entry_filter(entry : HistEntry, histignore):
  if( not entry.command[0].isalpha() or entry.command.strip() in histignore.split(":")):
    print("---",entry)
    return True
  print("+++",entry)
  return False


if __name__ == "__main__":
  import argparse
  import sys, os

  default_histfile = os.getenv("histfile","~/.history")

  try:
    default_histcount = int(os.getenv("history",None))
  except (TypeError, ValueError):
    default_histcount=None

  default_histignore = os.getenv("HISTIGNORE","")


  parser = argparse.ArgumentParser()
  parser.add_argument("histfile", nargs="?", default=default_histfile)
  parser.add_argument("histcount", nargs="?", type=int, default=default_histcount)
  parser.add_argument("histignore", nargs="?",  default=default_histignore)

  args=parser.parse_args()
  if(args.histfile is not None and Path(args.histfile).exists()):
    entries = parse_history(args.histfile)
    print(len(entries))
    entries = [e for e in entries if not entry_filter(e,args.histignore)]
    save_history(args.histfile, args.histcount, entries)
  else:
    print("No Histfile")
