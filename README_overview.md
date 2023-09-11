### Workflow overview


```mermaid
graph TB;

    classDef Output fill:#6082B6,stroke:#6082B6,stroke-width:2px,color:#fff;
    classDef Input fill:#A7C7E7,stroke:#A7C7E7,stroke-width:2px;
    classDef Process fill:#96DED1,stroke:#96DED1,stroke-width:2px;

    subgraph download
        direction TB;
        A([SRA IDs list]):::Input --> A2["download\nfasterq-dump"]:::Process;
        A2 --> B(["raw reads"]):::Output;
        B --> D["stats\nseqkit"];
        D:::Process --- E(["encoding\nread length\npairing"]);
        E:::Output --> G(["config files"]):::Output;
        B ----> B2(["raw reads"]):::Output;
    end

    subgraph genconf
        direction TB;
        C(["raw reads"]):::Input ---> I(["config files"]):::Output;
        C ---> C2(["raw reads"]):::Output
    end

    subgraph mapping
        direction TB;
        H(["config files"]):::Output --> J[trimming]:::Process;
        H2(["raw reads"]):::Output --> J[trimming]:::Process;
        H3(["reference"]):::Output --> J[trimming]:::Process;
        J --- K[mapping]:::Process;
        K --- L[marking duplicates]:::Process;
        L --> M(["mapped reads"]):::Output;
    end

    subgraph snps
        direction TB;
        CN["generate config"]:::Process --> CN2(["config file"]):::Output;
        SI(["mapped reads"]):::Output --> S1["variant calling"]:::Process;
        R(["reference"]):::Output --> S1["variant calling"]:::Process;
        CN2 --> S1;
        S1 --- S2["overview"]:::Process;
        S2 --- S3["filtering"]:::Process;
        S3 --- S4["variant effects"]:::Process;
        S4 --- S5["annotation"]:::Process;
        S5 --> S6(["filtered variants"]):::Output;
        GFF(["Gff"]):::Input ----> S4;
        GFF(["Gff"]):::Input -----> S5;
    end
    
    subgraph main
        direction TB;
        G -.-> H;
        I -.-> H;
        B2 -.-> H2;
        C2 -.-> H2;
        M -.-> SI;
        M -.-> CN;
        H3 -.-> R;
        H3 -.-> CN;
    end
    
    classDef subg fill:#fff,color:#fff,stroke:#A7C7E7
    class download,genconf,mapping,snps subg
	
    classDef maing fill:#fff,color:#fff,stroke:#fff
    class main maing

```
