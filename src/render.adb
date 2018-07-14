with Numworks.Display;
with Numworks.Backlight;

with HAL;                     use HAL;
with Bitmap_Color_Conversion;
with HAL.Bitmap;              use HAL.Bitmap;

package body Render is

   Buffer : aliased GESTE.Output_Buffer :=
     (1 .. Numworks.Display.Width * 10 => 0);

   Screen_Pt : GESTE.Point := (0, 0);

   ---------
   -- Put --
   ---------

   procedure Push_Pixels (Buffer : GESTE.Output_Buffer) is
      Temp : UInt16_Array (Buffer'Range)
        with Address => Buffer'Address;
   begin
      Numworks.Display.Push_Pixels (Temp, DMA_Theshold => 5000);
      Numworks.Display.Wait_End_Of_Push;
   end Push_Pixels;

   ----------------------
   -- Set_Drawing_Area --
   ----------------------

   procedure Set_Drawing_Area  (Area : GESTE.Rect) is
   begin
      Numworks.Display.Set_Drawing_Area (((Area.TL.X - Screen_Pt.X,
                                         Area.TL.Y - Screen_Pt.Y),
                                         Area.BR.X - Area.TL.X + 1,
                                         Area.BR.Y - Area.TL.Y + 1));
      Numworks.Display.Start_Pixel_Write;
   end Set_Drawing_Area;

   -----------------------
   -- Set_Screen_Offset --
   -----------------------

   procedure Set_Screen_Offset (Pt : GESTE.Point) is
   begin
      Screen_Pt := Pt;
   end Set_Screen_Offset;

   ----------------
   -- Render_All --
   ----------------

   procedure Render_All (Background : GESTE_Config.Output_Color) is
   begin
      GESTE.Render_All
        ((Screen_Pt,
         (Screen_Pt.X + Numworks.Display.Width - 1,
          Screen_Pt.Y + Numworks.Display.Height - 1)),
         Background,
         Buffer,
         Push_Pixels'Access,
         Set_Drawing_Area'Access);
   end Render_All;

   ------------------
   -- Render_Dirty --
   ------------------

   procedure Render_Dirty (Background : GESTE_Config.Output_Color) is
   begin
      GESTE.Render_Dirty
        ((Screen_Pt,
         (Screen_Pt.X + Numworks.Display.Width - 1,
          Screen_Pt.Y + Numworks.Display.Height - 1)),
         Background,
         Buffer,
         Push_Pixels'Access,
         Set_Drawing_Area'Access);
   end Render_Dirty;

   ---------------
   -- Dark_Cyan --
   ---------------

   function Dark_Cyan return GESTE_Config.Output_Color
   is (GESTE_Config.Output_Color (Bitmap_Color_Conversion.Bitmap_Color_To_Word
                                  (RGB_565, HAL.Bitmap.Dark_Cyan)));

   -----------
   -- Black --
   -----------

   function Black return GESTE_Config.Output_Color
   is (0);

begin

   Numworks.Backlight.Set_Level (16);

end Render;
