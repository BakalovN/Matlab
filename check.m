
%Checks which blocks are not builded properly
function check(repair) 
    createLogFileHeader;

    fprintf("Inport green -----------------------------------------------\n");
    writeTypeOfBlock("INPORT");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Inport'), "green", repair);
    fprintf("End Inport green -------------------------------------------\n");
    fprintf("Outport red ------------------------------------------------\n");
    writeTypeOfBlock("OUTPORT");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Outport'), "red", repair);
    fprintf("End Outport red --------------------------------------------\n");
    fprintf("Product yellow ---------------------------------------------\n");
    writeTypeOfBlock("PRODUCT");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Product'), "yellow", repair);
    fprintf("End product yellow------------------------------------------\n");
    fprintf("Subsystem white---------------------------------------------\n");
    writeTypeOfBlock("SUBSYSTEM");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Subsystem'), "white", repair);
    fprintf("End Subsystem white-----------------------------------------\n");
    fprintf("Gain gray---------------------------------------------------\n");
    writeTypeOfBlock("GAIN");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Gain'), "grey", repair);
    fprintf("End Gain gray-----------------------------------------------\n");
    fprintf("Delay black-------------------------------------------------\n");
    writeTypeOfBlock("DELAY");
    forLoopBackgroundColor(find_system('ColorCoded', 'BlockType', 'Delay'), "black", repair);
    fprintf("End Delay black---------------------------------------------\n");
    fprintf("Sum round---------------------------------------------------\n");
    writeTypeOfBlock("SHAPE_SUM");
    forLoopIconShape(find_system('ColorCoded', 'BlockType', 'Sum'), "Round", repair);
    fprintf("End Sum round-----------------------------------------------\n");
    %createLogFileFooter;
    
end

function forLoopBackgroundColor(blocks, desiredColor, repair)
    for iterator = 1 : length(blocks)
        if(repair)
            set_param(blocks{iterator}, 'BackgroundColor', desiredColor);
            repairLogHTML(blocks{iterator});
        elseif get_param(blocks{iterator}, 'BackgroundColor') ~= desiredColor
            fprintf('%s: - False!\n',blocks{iterator});
            writeToLogFile(sprintf('%s\n', blocks{iterator}));
        end
    end
end

function forLoopIconShape(subSystemPaths, desiredShape, repair)
    for iterator = 1 : length(subSystemPaths)
        partsOfPath = split(subSystemPaths{iterator}, "/");
        if ismember("Audi", partsOfPath)
            if(repair)
                set_param(subSystemPaths{iterator}, 'IconShape', desiredShape);
                repairLogHTML(subSystemPaths{iterator});
            elseif get_param(subSystemPaths{iterator}, 'IconShape') ~= desiredShape
            fprintf('%s: - False!\n',subSystemPaths{iterator});
            writeToLogFile(sprintf('%s\n', subSystemPaths{iterator})); 

            end
        end
    end
end

function repairLogHTML(blockPath)
    fileId = fopen("log.html", "a");
    fprintf(fileId, sprintf('<tr>\n    <th>%s: REPAIRED%s</th>\n</tr>\n', blockPath));
    fclose(fileId);
end

%HTML log file----------------------------------------------------------------
function createLogFileHeader
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
    fileId = fopen("log.html", "a");
    fprintf(fileId, sprintf('<tr id="%s">\n    <th>%s</th>\n</tr>\n',typeOfBlock, typeOfBlock));
    fclose(fileId);
end

function writeToLogFile(message)
    fileId = fopen("log.html", "a");
    fprintf(fileId, sprintf('<tr>\n    <th> %s </th>\n</tr>\n', message));
    fclose(fileId);
end

function createLogFileFooter
fileId = fopen("log.html", "a");
fprintf(fileId, '</table>\n</body>\n</html>\n');
end
%End HTML log file-------------------------------------------------------------