let type =  fn x ->
  case x do
      1 ->
          :number;
      3..10 ->
          :range;
      [] ->
          :list;
      {} ->
          :record
  end
;;
