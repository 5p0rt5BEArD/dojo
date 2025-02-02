use array::ArrayTrait;
use serde::Serde;

impl ArrayU32Serde of Serde::<Array::<u32>> {
    fn serialize(ref serialized: Array::<felt>, mut input: Array::<u32>) {
        Serde::<usize>::serialize(ref serialized, input.len());
        serialize_array_u32_helper(ref serialized, ref input);
    }
    fn deserialize(ref serialized: Array::<felt>) -> Option::<Array::<u32>> {
        let length = Serde::<felt>::deserialize(ref serialized)?;
        let mut arr = ArrayTrait::new();
        deserialize_array_u32_helper(ref serialized, arr, length)
    }
}

fn serialize_array_u32_helper(ref serialized: Array::<felt>, ref input: Array::<u32>) {
    // TODO(orizi): Replace with simple call once inlining is supported.
    match try_fetch_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('Out of gas');
            panic(data);
        },
    }
    match input.pop_front() {
        Option::Some(value) => {
            Serde::<u32>::serialize(ref serialized, value);
            serialize_array_u32_helper(ref serialized, ref input);
        },
        Option::None(_) => {},
    }
}

fn deserialize_array_u32_helper(
    ref serialized: Array::<felt>, mut curr_output: Array::<u32>, remaining: felt
) -> Option::<Array::<u32>> {
    // TODO(orizi): Replace with simple call once inlining is supported.
    match try_fetch_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('Out of gas');
            panic(data);
        },
    }
    if remaining == 0 {
        return Option::<Array::<u32>>::Some(curr_output);
    }
    curr_output.append(Serde::<u32>::deserialize(ref serialized)?);
    deserialize_array_u32_helper(ref serialized, curr_output, remaining - 1)
}
