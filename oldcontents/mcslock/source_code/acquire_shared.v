    Definition acquire_shared0_spec (valid_arg: Z -> option positive) (index ofs:Z) (adt: RData):
      option (RData * positive * (option (list Integers.Byte.int))) :=
      let cpu := CPU_ID adt in
      match (ikern adt, ihost adt, index2Z index ofs, valid_arg index) with
        | (true, true, Some abid, Some id) =>
          match ZMap.get abid (multi_log adt) with
            | MultiDef l =>
              match CalValidBit l with
                | Some FreeToPull =>
                  match GetSharedMemEvent l with
                    | Some e => Some (adt {multi_log: ZMap.set abid (MultiDef ((TEVENT cpu (TSHARED OPULL)) :: l)) (multi_log adt)}
                                      , id, Some e)
                    | _ => Some (adt {multi_log: ZMap.set abid (MultiDef ((TEVENT cpu (TSHARED OPULL)) :: l)) (multi_log adt)}
                                 , id, None)
                  end
                | _ => None
              end
            | _ => None
          end
        | _ => None
      end.

