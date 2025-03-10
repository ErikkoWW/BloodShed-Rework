# bufferinterface-gmod

## BufferInterface

A wrapper for Net and File buffers. The purpose behind this library is to unify different buffers under single buffer type, which then can be passed as function argument to some buffer reader or writer. In addition, it can be used for writing and reading unsigned integers and null terminated strings in binary files, which original File object lacks such methods.

Supported buffers:
* [Net](http://wiki.garrysmod.com/page/Category:net) (pass `"net"` as argument)
* [File](http://wiki.garrysmod.com/page/Category:File)

The library returns a function. When some buffer is passed as argument to the function, it will create new `BufferInterface` object.
```lua
local BufferInterface = include("bufferinterface.lua")
local fl = file.Open( "somefile.dat", "wb", "DATA" )
local buffer = BufferInterface( fl )
buffer:WriteInt8(-64)
fl:Close()
```

Available methods:

* `BufferInterface:WriteDouble( number double )`
* `BufferInterface:ReadDouble()`\
  returns: `number double`


* `BufferInterface:WriteFloat( number float )`
* `BufferInterface:ReadFloat( )`\
  returns: `number float`
  
  
* `BufferInterface:WriteInt32( number int32 )`
* `BufferInterface:ReadInt32( )`\
  returns: `number int32`
  
  
* `BufferInterface:WriteUInt32( number int32 )`
* `BufferInterface:ReadUInt32( )`\
  returns: `number int32`
  
  
* `BufferInterface:WriteInt16( number int16 )`
* `BufferInterface:ReadInt16( )`\
  returns: `number int16`
  
  
* `BufferInterface:WriteUInt16( number int16 )`
* `BufferInterface:ReadUInt16( )`\
  returns: `number int16`
  
  
* `BufferInterface:WriteInt8( number int8 )`
* `BufferInterface:ReadInt8( )`\
  returns: `number int8`
  
  
* `BufferInterface:WriteUInt8( number int8 )`
* `BufferInterface:ReadUInt8( )`\
  returns: `number int8`


* `BufferInterface:WriteVector( Vector vec )`
* `BufferInterface:ReadVector( )`\
  returns: `Vector vec`
  
  
* `BufferInterface:WriteBool( boolean bool )`
* `BufferInterface:ReadBool( )`\
  returns: `boolean bool`
  
  
* `BufferInterface:WriteString( string str )`
* `BufferInterface:ReadString( )`\
  returns: `string str`
  
  
* `BufferInterface:WriteData( string str, number len )`
* `BufferInterface:ReadData( len )`\
  returns: `string str`
  
  
* `BufferInterface:Seek( pos )`\
  This is not supported when used with net library.\
* `BufferInterface:Tell( )`\
  This is not supported when used with net library.\
  returns: `number pos`
  
  
* `BufferInterface:Size( )`\
  returns: `number size`

  
### Example

```lua
local BufferInterface = include("bufferinterface.lua")
local Stream = include("stream.lua")
if SERVER then
	util.AddNetworkString( "BufferInterface_Example" )
end

local function SomeBufferWriter( buf )
	buf:WriteString( "Hello There!" )
    buf:WriteDouble( 1/3 )
    buf:WriteFloat( 1/3 )
end

local function SomeBufferReader( buf )
	print( buf:ReadString() )
    print( buf:ReadDouble() )
    print( buf:ReadFloat() )
end

--------------------------------------------------------------------------------

-- Net library writing
if SERVER then
	net.Start( "BufferInterface_Example" )
	
    local buf_net = BufferInterface( "net" )
	SomeBufferWriter( buf_net )
	
    net.Broadcast()
end

-- File writing
local fl = file.Open( "somefile.dat", "wb", "DATA" )
local buf_fl = BufferInterface( fl )
SomeBufferWriter( buf_fl )
fl:Close()

-- Stream writing
local buf_stream = Stream()
SomeBufferWriter( buf_stream )

--------------------------------------------------------------------------------

if CLIENT then
    net.Receive( "BufferInterface_Example", function( len )
		print "Net library reading"
        SomeBufferReader( BufferInterface( "net" ) )
    end )
end

print "File reading"
local fl = file.Open( "somefile.dat", "rb", "DATA" )
local buf_fl = BufferInterface( fl )
SomeBufferReader( buf_fl )
fl:Close()

print "Stream reading"
buf_stream:Seek(0)
SomeBufferReader( buf_stream )

```

Output:
```
Net library reading
Hello There!
0.33333333333333
0.33333334326744
```
```
File reading
Hello There!
0.33333333333333
0.33333334326744
``` 
```
Stream reading
Hello There!
0.33333333333333
0.33333334326744
```