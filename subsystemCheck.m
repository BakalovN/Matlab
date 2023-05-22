function subsystemCheck
connectedToSubSystem('Inport');
connectedToSubSystem('Outport');
end

function connectedToSubSystem(blockType)
if (strcmp(blockType,'Inport'))
    inportBlocks = find_system('ColorCoded', 'BlockType', blockType);
    findBlocks(inportBlocks);

elseif (strcmp(blockType,'Outport'))
    outportBlocks = find_system('ColorCoded', 'BlockType', blockType);
    findBlocks(outportBlocks);

end
end


function findBlocks(blocks)

for iterator = 1 : length(blocks)
    currentBlock = blocks{iterator};
    portConnectivityProperty = struct2cell(get_param(currentBlock, 'PortConnectivity'));

    if strcmp(get_param(currentBlock, 'BlockType'), "Inport")
        handlePropertyOfConnectedBlocks = portConnectivityProperty{5};
    elseif strcmp(get_param(currentBlock, 'BlockType'), "Outport")
        handlePropertyOfConnectedBlocks = portConnectivityProperty{3};
    end

    subsystemBlocks = get_param(find_system('ColorCoded', 'BlockType', 'SubSystem'), 'Handle');

    for subsystemSearch = 1 : length(subsystemBlocks)
        for connectedBlocksSearch = 1 : length(handlePropertyOfConnectedBlocks)
            if (subsystemBlocks{subsystemSearch}==handlePropertyOfConnectedBlocks(connectedBlocksSearch))
                pinkColoring(currentBlock)
            end
        end
    end
end

end


function pinkColoring(currentBlock)

if ~strcmp(get_param(currentBlock, 'BackgroundColor'), "magenta")
    set_param(currentBlock, 'BackgroundColor', 'magenta')
end
end