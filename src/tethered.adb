-- Name: Elias Afzalzada
-- Email: eafzalzada@radford.edu
-- Course: Itec 320
-- Homework #: 4
-- Link: https://www.radford.edu/~itec320//2018fall-ibarland/Homeworks/hw04.html#back-2
-- Purpose: Determine Shopping path of either going forward or backward using
-- a 2d array along with functions and procedures to help solve the problem

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.integer_Text_IO;
with Ada.Float_Text_IO; use Ada.float_Text_IO;

procedure Tethered is

   -- Easy to access constants to change 2D array sizes for the grocery store inventory
   MAX_AISLES: constant := 1_000;
   MIN_AISLES : constant := 1;
   MAX_LOCATION : constant := 100;
   MIN_LOCATION: constant := 0;

   -- Used to model the stores inventory in a 2darray
   type storeInventoryA2D is array(Natural range <>, Natural range <>) of boolean;

   -- Helped to determine what direction to proceed in the aisle
   type direction is (contin, rever);

   -- Helps determine which end to start in the aisle
   subtype aisleStart is Natural range MIN_LOCATION .. MAX_LOCATION;

   -- Reads input and calculates how many total aisles there are
   procedure readInput (productLocations: in out storeInventoryA2D) is
      aisleInput: Integer;
      locationInput: Integer;
   begin
      -- loops until end of file and stores all into an 2darray
      while not End_Of_File loop
         Get(aisleInput);
         Get(locationInput);
         -- EXTRA CREDIT: checks if there are any items at all to input
         if aisleInput in 1 .. 1_000 then
            if locationInput in 0 .. 100 then
               productLocations(aisleInput, locationInput) := True;
            end if;
         end if;
      end loop;
   end readInput;

   -- Calculates Tethered output and prints all tethered output
   procedure calculateTetheredOutput (productLocations: in out storeInventoryA2D) is

      -- Running data setup for tethered procedure
      directionTravel:  String := "Continue";
      aisleStartPos: aisleStart := aisleStart'first;
      previousAisle, lastLocationVisited, totalTraveled, lastTravel: Integer := 0;
      totalAisles, totalDistance: Integer := 0;
      avg: float := 0.0;

   begin
      --2D Array control loop to pass through array for near tethered half
      Put_Line("Tethered: ");
      for currentAisle in productLocations'range(1) loop
         for currentLocation in aisleStart'First .. 49 loop

            --2D array location to check if product is there
            if productLocations(currentAisle,currentLocation) = True
              and productLocations(currentAisle,currentLocation + 1) = False then

               --calculation increments
               previousAisle := currentAisle;
               lastLocationVisited := currentLocation;
            end if;
         end loop;

         --used to handle errors in gapped locations in the same aisle
         if currentAisle = previousAisle then

            --current line calculation along with summary calculations
            totalAisles := totalAisles + 1;
            totalTraveled := lastTravel + lastLocationVisited;
            totalDistance := totalDistance + totalTraveled;
            lastTravel := lastLocationVisited;

            --near half line output
            Put(directionTravel & " and enter aisle");
            Put(previousAisle, 5);
            Put(" at");
            Put(aisleStartPos, 4);
            Put(" proceed to location");
            Put(lastLocationVisited, 4);
            Put(", traveling");
            Put(totalTraveled, 4);
            New_Line;
            directionTravel := "Reverse ";
         end if;
      end loop;

      directionTravel := "Continue";
      --2D Array control loop to pass through array for far tethered half
      for currentAisle in reverse productLocations'range(1) loop
         for currentLocation in reverse 50 .. aisleStart'last loop
            aisleStartPos := aisleStart'last;
            if productLocations(currentAisle,currentLocation) = True
              and productLocations(currentAisle,currentLocation - 1) = False then

               --calculation increments
               previousAisle := currentAisle;
               lastLocationVisited := currentLocation;
               totalAisles := totalAisles + 1;
               totalTraveled := 100 - lastTravel + 100 - lastLocationVisited;
               totalDistance := totalDistance + totalTraveled;
               lastTravel := lastLocationVisited;

               -- far half line output
               Put(directionTravel & " and enter aisle");
               Put(previousAisle, 5);
               Put(" at");
               Put(aisleStartPos, 4);
               Put(" proceed to location");
               Put(lastLocationVisited, 4);
               Put(", traveling");
               Put(totalTraveled, 4);
               New_Line;
               directionTravel := "Reverse ";
            end if;
         end loop;
      end loop;

      -- final outputs for tethered exit line and total running summary
      if End_Of_File then
         -- Exit line output
         directionTravel := "Continue";
         Put(directionTravel & " and exit  aisle");
         Put(previousAisle, 5);
         Put(" at   0");
         Put(" proceed to cashier");
         Put(",      traveling");
         Put(lastLocationVisited, 4);

         --Tethered summary output and final calculation
         Avg := Float(totalDistance / totalAisles);
         New_Line(2);
         put("Aisle count: ");
         Put(totalAisles, 0);
         New_Line;
         Put("Total distance: ");
         Put(totalDistance, 0);
         New_Line;
         Put("Average:");
         put(avg, fore => 3, aft => 1, exp => 0);
      end if;
   end calculateTetheredOutput;

   -- Calculates untethered output and prints all untethered output
   procedure calculateUntetheredOutput (productLocations: in out storeInventoryA2D) is

      -- Running data setup for tethered procedure
      directionTravel:  String := "Continue";
      aisleStartPos: aisleStart := aisleStart'first;
      previousAisle, lastLocationVisited, totalTraveled, lastTravel: Integer := 0;
      totalAisles, totalDistance: Integer := 0;
      avg: float := 0.0;

   begin
      --2D Array control loop to pass through array for near tethered half
      New_Line(2);
      Put_Line("Untethered: ");
      for currentAisle in productLocations'range(1) loop
         for currentLocation in aisleStart'First .. aisleStart'Last loop

            --2D array location to check if product is there
            if productLocations(currentAisle,currentLocation) = True then

               --calculation increments
               previousAisle := currentAisle;
               lastLocationVisited := currentLocation;
            end if;
         end loop;

         --used to prevent skipped locations double outputs and print correctly
         if currentAisle = previousAisle then

           -- if lastLocationVisited - 100 > productLocations(currentAisle, lastLocationVisited) then
           -- direction := "Reverse "
           -- elsif lastLocationVisited - 100 > productLocations(currentAisle, lastLocationVisited) then
           -- direction := "Continue"

            --current line calculation along with summary calculations
            totalAisles := totalAisles + 1;
            totalTraveled := lastTravel + lastLocationVisited;
            totalDistance := totalDistance + totalTraveled;
            lastTravel := lastLocationVisited;

            --near half line output
            Put(directionTravel & " and enter aisle");
            Put(previousAisle, 5);
            Put(" at");
            Put(aisleStartPos, 4);
            Put(" proceed to location");
            Put(lastLocationVisited, 4);
            Put(", traveling");
            Put(totalTraveled, 4);
            New_Line;
            directionTravel := "Reverse ";

            --end if;
            --end if;
         end if;
      end loop;

      -- final outputs for untethered exit line and total running summary
      if End_Of_File then
         -- Exit line output
         Put(directionTravel & " and exit  aisle");
         Put(previousAisle, 5);
         Put(" at   0");
         Put(" proceed to cashier");
         Put(",      traveling");
         Put(lastLocationVisited, 4);

         --Tethered summary output and final calculation
         Avg := Float(totalDistance / totalAisles);
         New_Line(2);
         put("Aisle count: ");
         Put(totalAisles, 0);
         New_Line;
         Put("Total distance: ");
         Put(totalDistance, 0);
         New_Line;
         Put("Average:");
         put(avg, fore => 3, aft => 1, exp => 0);
      end if;

   end calculateUntetheredOutput;

   --Note: decided to not use print procedure however noted on severeal
   --occasion that using one would of been more efficient
   -- print's summary totals for whichever algorthm called it
   --procedure printSummary (totalAisles: Integer) is
   --begin
   --Put_Line(totalAisles'Img & " Testing output called");
   --end printSummary;

   --2D array setup
   productLocations: storeInventoryA2D(
   MIN_AISLES .. MAX_AISLES,
   MIN_LOCATION .. MAX_LOCATION)
   := (others => (others => False));

begin
   readInput(productLocations);
   calculateTetheredOutput(productLocations);
   calculateUntetheredOutput(productLocations);
   --printSummary(totalAisles);
end Tethered;
