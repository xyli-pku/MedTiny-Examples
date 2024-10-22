# How to use

To generate PRISM model from the MedTiny model `paxos.mt`, run the following command

```
java -jar MedTiny0.9.jar paxos/paxos.mt
```

With some manual modification, we can use PRISM to verify the properties in `paxos.props`.

Basically, these properties state that the Paxos Protocol will eventually lead to consensus.

A simpler model (with only one proposer, instead of two) is defined in `paxos_simple.mt`, and a more complex model is given in `paxos_complex.mt`, which also takes message duplication and message loss into consideration.

