RaycastPositionSensor = class(nil);
RaycastPositionSensor.maxParentCount = -1; --inputs
RaycastPositionSensor.maxChildCount = -1;  --outputs
RaycastPositionSensor.connectionInput = sm.interactable.connectionType.power;
RaycastPositionSensor.connectionOutput = sm.interactable.connectionType.power;

RaycastPositionSensor.colorNormal = sm.color.new(0x009999ff);
RaycastPositionSensor.colorHighlight = sm.color.new(0x11B2B2ff);

OR, XOR, AND = 1, 3, 4

function Bitoper(a, b, oper)
    local r, m, s = 0, 2 ^ 31, nil
    repeat
        s, a, b = a + b + m, a % m, b % m
        r, m = r + m * oper % (s - a - b), m / 2
    until m < 1
    return r
end

function RaycastPositionSensor.server_onRefresh(self)
    self:server_onCreate();
end

function RaycastPositionSensor.server_onCreate(self)
    self.col_ray = sm.vec3.new(0, 0, 0);
    print('RaycastPositionSensor created')
end

function RaycastPositionSensor.server_onFixedUpdate(self, dt)
    -- go through all inputs and get the max_ray_distance
    local max_ray_distance = 0;
    for k, v in pairs(self.interactable:getParents()) do
        if v:hasOutputType(sm.interactable.connectionType.power) then
            -- if the parent is white, then use it
            if v:getShape():getColor() == sm.color.new(0xeeeeeeff) then
                max_ray_distance = max_ray_distance + v.power;
            end
        end
    end
    -- if max_ray_distance is 0, then use 100
    if max_ray_distance == 0 then
        max_ray_distance = 100;
    end
    local start = self.shape.worldPosition;
    local stop = start + self.shape.worldRotation * sm.vec3.new(0, 0, 1) * max_ray_distance;
    local hit, raycastResult = sm.physics.raycast(start, stop);
    if hit then
        self.col_ray = raycastResult.pointWorld;
    else
        self.col_ray = stop;
    end
    for k, v in pairs(self.interactable:getChildren()) do
        if Bitoper(v:getConnectionInputType(), sm.interactable.connectionType.power, AND) == sm.interactable.connectionType.power then
            if v:getShape():getColor() == sm.color.new(0xd02525ff) then
                v.power = self.col_ray.x;
            elseif v:getShape():getColor() == sm.color.new(0x19e753ff) then
                v.power = self.col_ray.y;
            elseif v:getShape():getColor() == sm.color.new(0x0a3ee2ff) then
                v.power = self.col_ray.z;
            end
        end
    end
end

-- DEBUG PARTICLES:
-- function RaycastPositionSensor.client_onUpdate(self)
--     -- create weld particle effect
--     sm.particle.createParticle("construct_welding", self.col_ray);
-- end
