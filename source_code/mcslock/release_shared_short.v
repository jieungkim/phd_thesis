    Function release_shared0_spec (valid_arg: Z -> option positive) (index ofs :Z) 
             (e: (list Integers.Byte.int)) (adt: RData) :=
      let cpu := CPU_ID adt in
      match (ikern adt, ihost adt, index2Z index ofs, valid_arg index) with
        | (true, true, Some abid, Some id) => 
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
