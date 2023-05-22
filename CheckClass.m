classdef CheckClass < handle

    properties
        repair
        inputColor
        outputColor
        productColor
        subsystemColor
        gainColor
        delayColor
        sumShape
    end

    methods (Access = public)
%CONSTRUCTOR ----------------------------------------------------------------
%USES INPUT PARSER (SEE iPARSER METHOD)
%CALLS CHECK FUNCTION
%----------------------------------------------------------------------------
        function obj = CheckClass(varargin)
            obj.iParser(varargin);
            obj.check();
        end
    end

    methods
        function blockChanger(obj, inputType, desiredProperty)
%BLOCKCHANGER METHOD -------------------------------------------------------
%HAVE 3 PARAMETERS 
%CHESKS IF THE INPUT TYPE IS SUM OR OTHER BLOCK
%THE SHAPE OF THE SUM BLOCK HAS TO BE CHANGED
%THE COLOR OF THE OTHER BLOCKS HAS TO BE CHANGED
            formattedInput = upper(inputType);
            writeTypeOfBlock(formattedInput);
            fprintf("%s %s -----------------------------------------------\n", inputType, desiredProperty);
            if (inputType == "Sum")
                find_system('ColorCoded', 'Name','Audi', 'BlockType', 'Subsytem')
                obj.forLoopIconShape(find_system('ColorCoded', 'BlockType', inputType), desiredProperty);
            else
                obj.forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', inputType), desiredProperty);
            end
            fprintf("End %s %s -----------------------------------------------\n", inputType, desiredProperty);
        end
    end

    methods (Access = private)
        function iParser(obj, args)
%INPUT PARSER --------------------------------------------------------------
%SETS DEFAULT VALUES FOR THE BLOCKS AND FOR THE REPAIR FUNCTION
            p = inputParser;
            addParameter(p, 'repair', false, @islogical);
            addParameter(p, 'inputColor', 'green', @isstring);
            addParameter(p, 'outputColor', 'red', @isstring);
            addParameter(p, 'productColor', 'yellow', @isstring);
            addParameter(p, 'subsystemColor', 'white', @isstring);
            addParameter(p, 'gainColor', 'grey', @isstring);
            addParameter(p, 'delayColor', 'black', @isstring);
            addParameter(p, 'sum', 'round', @isstring);
            p.parse(args{:});
            obj.repair = p.Results.repair;
            obj.inputColor = p.Results.inputColor;
            obj.outputColor = p.Results.outputColor;
            obj.productColor = p.Results.productColor;
            obj.subsystemColor = p.Results.subsystemColor;
            obj.gainColor = p.Results.gainColor;
            obj.delayColor = p.Results.delayColor;
            obj.sumShape = p.Results.sum;
        end

        function check(obj)
%CHECK METHOD---------------------------------------------------------------
%CALLS THE createLogFileHeader METHOD
%CALLS THE blockChanger METHOD WITH ALL NEEDED INPUTS
%CALLS THE createLogFileFooter METHOD
            createLogFileHeader;

            obj.blockChanger('Inport', obj.inputColor);
            obj.blockChanger('Outport', obj.outputColor);
            obj.blockChanger('Product', obj.productColor);
            obj.blockChanger('SubSystem', obj.subsystemColor);
            obj.blockChanger('Gain', obj.gainColor);
            obj.blockChanger('Delay', obj.delayColor);
            obj.blockChanger('Sum', obj.sumShape);


            createLogFileFooter;

        end

        function forLoopBackgroundColor(obj, blocks, desiredColor)
%FOR LOOP BACKGROUND COLOR ---------------------------------------------------
%CHECKS IF THE REPEIR FLAG IS TRUE AND IF THE COLOR IS NOT RIGHT
%IF SO THE BLOCK IS REPAIRED AND THE THE REPAIR IS WRITTEN IN THE LOG FILE
%ELSE IN THE LOG FILE ARE WRITTEN THE WRONG BLOCKS
            for iterator = 1 : length(blocks)
                if(obj.repair && ~strcmp(get_param(blocks{iterator}, 'BackgroundColor'), desiredColor))
                    set_param(blocks{iterator}, 'BackgroundColor', desiredColor);
                    repairLogHTML(blocks{iterator});
                elseif ~strcmp(get_param(blocks{iterator}, 'BackgroundColor'), desiredColor)
                    fprintf('%s: - False!\n',blocks{iterator});
                    writeToLogFile(sprintf('%s\n', blocks{iterator}));
                end
            end
        end

        function forLoopIconShape(obj, subSystemPaths, desiredShape)
%FOR LOOP BLOCK SHAPE ---------------------------------------------------
%CHECKS IF THE REPEIR FLAG IS TRUE AND IF THE COLOR IS NOT RIGHT
%IF SO THE BLOCK IS REPAIRED AND THE THE REPAIR IS WRITTEN IN THE LOG FILE
%ELSE IN THE LOG FILE ARE WRITTEN THE WRONG BLOCKS
            for iterator = 1 : length(subSystemPaths)
                partsOfPath = split(subSystemPaths{iterator}, "/");
                if ismember("Audi", partsOfPath)
                    if(obj.repair && ~strcmp(get_param(subSystemPaths{iterator}, 'IconShape'), desiredShape))
                        set_param(subSystemPaths{iterator}, 'IconShape', desiredShape);
                        repairLogHTML(subSystemPaths{iterator});
                    elseif ~strcmp(get_param(subSystemPaths{iterator}, 'IconShape'), desiredShape)
                        fprintf('%s: - False!\n',subSystemPaths{iterator});
                        writeToLogFile(sprintf('%s\n', subSystemPaths{iterator}));

                    end
                end
            end
        end
    end
end

function repairLogHTML(blockPath)
%ADDS THE NAMES OF THE REPAIRED BLOCKS TO THE LOG FILE
fileId = fopen("log.html", "a");
fprintf(fileId, sprintf('<tr>\n    <th>%s: REPAIRED%s</th>\n</tr>\n', blockPath));
fclose(fileId);
end

function createLogFileHeader
%CREATES THE HTML LOG HEADER
fileId = fopen("log.html", "w");
fprintf(fileId, '<html>\n');
fprintf(fileId, '<style type="text/css">\n');
fprintf(fileId, 'table, th, td {');
fprintf(fileId, '  border:1px solid black;');
fprintf(fileId, '}\n');
fprintf(fileId, 'table tr#INPORT  {background-color:green; color:black;}');
fprintf(fileId, 'table tr#OUTPORT  {background-color:red; color:black;}');
fprintf(fileId, 'table tr#PRODUCT  {background-color:yellow; color:black;}');
fprintf(fileId, 'table tr#SUBSYSREM  {background-color:white; color:black;}');
fprintf(fileId, 'table tr#GAIN  {background-color:grey; color:black;}');
fprintf(fileId, 'table tr#DELAY  {background-color:black; color:white;}');
fprintf(fileId, 'table tr#SHAPE_SUM  {background-color:blue; color:white;}');
fprintf(fileId, '</style>\n');
fprintf(fileId, '<body>\n');
fprintf(fileId, '<h2>Table of logs</h2>\n');
fprintf(fileId, '<table style="width:100%%">\n');
fprintf(fileId, '<tr>\n<th>Paths</th>\n</tr>\n');
fclose(fileId);
end

function writeTypeOfBlock(typeOfBlock)
%ADDS THE TYPE OF BLOCK TO THE LOG FILE
fileId = fopen("log.html", "a");
fprintf(fileId, sprintf('<tr id="%s">\n    <th>%s</th>\n</tr>\n',typeOfBlock, typeOfBlock));
fclose(fileId);
end

function writeToLogFile(message)
%WRITES THE WRONG BLOCKS
fileId = fopen("log.html", "a");
fprintf(fileId, sprintf('<tr>\n    <th> %s </th>\n</tr>\n', message));
fclose(fileId);
end

function createLogFileFooter
%CREATES THE LOG FOOTER
fileId = fopen("log.html", "a");
fprintf(fileId, '</table>\n</body>\n</html>\n');
end

