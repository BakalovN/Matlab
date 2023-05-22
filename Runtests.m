classdef Runtests < matlab.unittest.TestCase
	properties (TestParameter)
		
	end

	methods (Test)
		function testClass(testCase)
			open_system('D:\Esprit Engeneering\ColorCoded');
			inportBlocks = find_system('ColorCoded', 'BlockType', 'Inport');
			outportBlocks = find_system('ColorCoded', 'BlockType', 'Outport');
			productBlocks = find_system('ColorCoded', 'BlockType', 'Product');
			subsystemBlocks = find_system('ColorCoded', 'BlockType', 'SubSystem');
			gainBlocks = find_system('ColorCoded', 'BlockType', 'Gain');
			delayBlocks = find_system('ColorCoded', 'BlockType', 'Delay');
			iconShapeSum = find_system('ColorCoded/Wok/Audi', 'BlockType', 'Sum');
			CheckClass('repair', true);
			for iterator = 1 : length(inportBlocks)
				blockColor = get_param(inportBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'green');
			end
			for iterator = 1 : length(outportBlocks)
				blockColor = get_param(outportBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'red');
			end
			for iterator = 1 : length(productBlocks)
				blockColor = get_param(productBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'yellow');
			end
			for iterator = 1 : length(subsystemBlocks)
				blockColor = get_param(subsystemBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'white');
			end
			for iterator = 1 : length(gainBlocks)
				blockColor = get_param(gainBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'grey');
			end
			for iterator = 1 : length(delayBlocks)
				blockColor = get_param(delayBlocks{iterator}, 'BackgroundColor');
				testCase.assertEqual(blockColor,'black');
			end
			for iterator = 1 : length(iconShapeSum)
				blockShape = get_param(iconShapeSum{iterator}, 'IconShape');
				testCase.assertEqual(blockShape,'round');
			end
			bdclose('D:\Esprit Engeneering\ColorCoded');
		end
	end
end