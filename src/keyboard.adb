with Numworks.Keyboard; use Numworks.Keyboard;

package body Keyboard is

   ------------
   -- Update --
   ------------

   procedure Update is
   begin
      Numworks.Keyboard.Scan;
   end Update;

   -------------
   -- Pressed --
   -------------

   function Pressed (Key : Key_Kind) return Boolean is
   begin
      return (case Key is
                 when Esc   => False,
                 when Up    => Pressed (A2) or Pressed (A5),
                 when Down  => Pressed (A3) or Pressed (A6),
                 when Left  => Pressed (A1),
                 when Right => Pressed (A4)
             );
   end Pressed;

end Keyboard;
