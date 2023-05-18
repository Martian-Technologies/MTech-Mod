OutputPort = class(nil);
OutputPort.maxParentCount = -1; --inputs
OutputPort.maxChildCount = -1;  --outputs
OutputPort.connectionInput = sm.interactable.connectionType.power;
OutputPort.connectionOutput = sm.interactable.connectionType.power;

OutputPort.colorNormal = sm.color.new(0x009999ff);
OutputPort.colorHighlight = sm.color.new(0x11B2B2ff);
