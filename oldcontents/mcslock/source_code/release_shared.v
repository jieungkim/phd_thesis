Function release_shared0_spec ... (adt: RData) :=
  ...
  match ZMap.get abid (multi_log adt) with
  | MultiDef l =>
              match CalValidBit l with
                | Some (PullBy i) =>
                  if zeq i cpu then
                    Some (adt {multi_log: ZMap.set abid (MultiDef ((TEVENT cpu (TSHARED (OMEME e))) :: l)) (multi_log adt)})
                  else None
                | _ => None
              end
            | _ => None
          end
        | _ => None
      end.
