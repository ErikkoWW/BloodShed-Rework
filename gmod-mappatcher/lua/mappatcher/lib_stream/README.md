# stream-gmod

## Stream

Buffer written in Lua, which stores individual bytes as number values inside table. Method names are exactly the same as `BufferInterface`, therefore it doesn't need to be wrapped. Can be used to write binary data, which then could be sent over http.

The library returns a callable table (acts as a function). When its called, it will create and return new `Stream` object. The data is stored in little-endian, unless true is passed as argument, which then it will store in big-endian.
```lua
local Stream = include("stream.lua")
local stream = Stream( )
stream:WriteInt8(-64)
print( stream:ToBase64( ) ) -- wA==
```

Available methods:

* `Stream:WriteDouble( number double )`
* `Stream:ReadDouble()`\
  returns: `number double`


* `Stream:WriteFloat( number float )`
* `Stream:ReadFloat( )`\
  returns: `number float`
  
  
* `Stream:WriteInt32( number int32 )`
* `Stream:ReadInt32( )`\
  returns: `number int32`
  
  
* `Stream:WriteUInt32( number int32 )`
* `Stream:ReadUInt32( )`\
  returns: `number int32`
  
  
* `Stream:WriteInt16( number int16 )`
* `Stream:ReadInt16( )`\
  returns: `number int16`
  
  
* `Stream:WriteUInt16( number int16 )`
* `Stream:ReadUInt16( )`\
  returns: `number int16`
  
  
* `Stream:WriteInt8( number int8 )`
* `Stream:ReadInt8( )`\
  returns: `number int8`
  
  
* `Stream:WriteUInt8( number int8 )`
* `Stream:ReadUInt8( )`\
  returns: `number int8`


* `Stream:WriteVector( Vector vec )`
* `Stream:ReadVector( )`\
  returns: `Vector vec`
  
  
* `Stream:WriteBool( boolean bool )`
* `Stream:ReadBool( )`\
  returns: `boolean bool`
  
  
* `Stream:WriteString( string str )`
* `Stream:ReadString( )`\
  returns: `string str`
  
  
* `Stream:WriteData( string str, number len )`
* `Stream:ReadData( len )`\
  returns: `string str`
  
  
* `Stream:Seek( pos )`
* `Stream:Tell( )`\
  returns: `number pos`
  
  
* `Stream:Size( )`\
  returns: `number size`
  
  
* `Stream:FromRawString( string raw )`\
  Clears the buffer, populates the buffer with given argument, and set pointer to 0.
* `Stream:ToRawString( )`\
  Returns the raw string of whole buffer.\
  returns: `string raw`
  
  
* `Stream:FromBase64( string base64 )`\
  Clears the buffer, populates the buffer with given argument, and set pointer to 0.
* `Stream:ToBase64( )`\
  Returns the base64 string of whole buffer.\
  returns: `string base64`
