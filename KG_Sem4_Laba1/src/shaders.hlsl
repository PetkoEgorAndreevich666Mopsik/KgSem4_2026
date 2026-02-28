// shaders.hlsl
cbuffer ObjectConstants : register(b0)
{
    float4x4 gWorldViewProj;
    float4 gUVTransform; // xy = scale, zw = offset
    float4 gBlendFactor; // x = blend factor (0-1) для интерполяции текстур
};

Texture2D gDiffuseMap1 : register(t0);
Texture2D gDiffuseMap2 : register(t1);
SamplerState gSampler : register(s0);

struct VertexIn
{
    float3 PosL : POSITION;
    float3 NormalL : NORMAL;
    float2 TexC : TEXCOORD;
};

struct VertexOut
{
    float4 PosH : SV_POSITION;
    float3 NormalW : NORMAL;
    float2 TexC : TEXCOORD;
};

VertexOut VS(VertexIn vin)
{
    VertexOut vout;

    // Transform to homogeneous clip space
    vout.PosH = mul(float4(vin.PosL, 1.0f), gWorldViewProj);

    // Pass normal through (assuming world is identity for now)
    vout.NormalW = vin.NormalL;

    // Apply UV transformation: scale then offset
    vout.TexC = vin.TexC * gUVTransform.xy + gUVTransform.zw;

    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
    // Sample both textures
    float4 texColor1 = gDiffuseMap1.Sample(gSampler, pin.TexC);
    float4 texColor2 = gDiffuseMap2.Sample(gSampler, pin.TexC);

    // Linear interpolation between two textures
    float4 finalColor = lerp(texColor1, texColor2, gBlendFactor.x);

    return finalColor;
}