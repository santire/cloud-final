import {
  Button,
  Divider,
  Group,
  Paper,
  SimpleGrid,
  Text,
  Textarea,
  TextInput,
  Image,
  Flex,
  ActionIcon,
  Alert,
} from "@mantine/core";
import { Dropzone, FileWithPath, IMAGE_MIME_TYPE } from "@mantine/dropzone";
import { IconAlertCircle, IconPhoto, IconUpload, IconX } from "@tabler/icons";
import { useState } from "react";
import { Controller, useForm, useFormContext } from "react-hook-form";
import { useMutation, useQueryClient } from "react-query";
import { useNavigate } from "react-router-dom";
import {
  createRecipe,
  RecipeForm as IRecipeForm,
} from "../../api/RecipeService";
import useStyles from "./RecipeForm.styles";

export function RecipeForm() {
  const { classes, theme } = useStyles();
  const { register, handleSubmit, setValue, control, reset } =
    useForm<IRecipeForm>();
  const [files, setFiles] = useState<FileWithPath[]>([]);
  const [showAlert, setShowAlert] = useState(false);

  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const { mutate, isLoading } = useMutation(createRecipe, {
    onSuccess: (data) => {
      console.log(data);
      navigate("/");
    },
    onError: (error) => {
      console.error(error);
      reset();
      setShowAlert(true);
    },
    onSettled: () => {
      queryClient.invalidateQueries("create");
    },
  });

  const previews = files.map((file, index) => {
    setValue("image", file);
    const imageURL = URL.createObjectURL(file);
    return (
      <div key={index}>
        <Image
          width="200px"
          height="200px"
          src={imageURL}
          imageProps={{ onLoad: () => URL.revokeObjectURL(imageURL) }}
        />
      </div>
    );
  });

  return (
    <Paper shadow="md" radius="lg">
      <Alert
        mb="xl"
        icon={<IconAlertCircle size={16} />}
        title="Error"
        color="red"
        hidden={!showAlert}
        withCloseButton
        onClose={() => setShowAlert(false)}
      >
        Algo anduvo mal, por favor intentá devuelta!
      </Alert>
      <div className={classes.wrapper}>
        <form
          className={classes.form}
          onSubmit={handleSubmit((values) => mutate(values))}
        >
          <Text className={classes.title} px="sm" mt="sm" mb="xl">
            Crear receta
          </Text>
          <div className={classes.fields}>
            <TextInput
              label="Titulo"
              placeholder="Titulo"
              required
              {...register("title")}
            />
            <Divider my="xs" label="" />
            <Textarea
              label="Receta"
              placeholder="Aqui va la receta"
              required
              {...register("body")}
            />
          </div>
          <Flex mt="sm" direction="column" hidden={files.length == 0} w={460}>
            <Text mb="xs">Imagen</Text>
            <Group>
              {previews}
              <ActionIcon onClick={() => setFiles([])}>
                <IconX />
              </ActionIcon>
            </Group>
          </Flex>
          <Controller
            control={control}
            {...register("image")}
            // register adds ref which produces error so....
            // @ts-ignore
            ref={null}
            render={({ field: { onChange } }) => (
              <Dropzone
                onDrop={(files) => {
                  setFiles(files);
                  console.log("accepted files", files);
                }}
                onReject={(files) => console.log("rejected files", files)}
                onChange={(e: any) => onChange(e.target.files[0])}
                maxSize={3 * 1024 ** 2}
                accept={IMAGE_MIME_TYPE}
                maxFiles={1}
                multiple={false}
                mt="xl"
                w={460}
                hidden={files.length > 0}
              >
                <Group
                  position="center"
                  spacing="xl"
                  style={{ minHeight: 220, pointerEvents: "none" }}
                >
                  <Dropzone.Accept>
                    <IconUpload
                      size={50}
                      stroke={1.5}
                      color={
                        theme.colors[theme.primaryColor][
                        theme.colorScheme === "dark" ? 4 : 6
                        ]
                      }
                    />
                  </Dropzone.Accept>
                  <Dropzone.Reject>
                    <IconX
                      size={50}
                      stroke={1.5}
                      color={
                        theme.colors.red[theme.colorScheme === "dark" ? 4 : 6]
                      }
                    />
                  </Dropzone.Reject>
                  <Dropzone.Idle>
                    <IconPhoto size={50} stroke={1.5} />
                  </Dropzone.Idle>

                  <div>
                    <Text size="xl" inline>
                      Arrastra una imagen aquí para agregarla
                    </Text>
                  </div>
                </Group>
              </Dropzone>
            )}
          />

          <Group position="center" mt="md">
            <Button
              type="submit"
              color="orange"
              fullWidth
              px="xl"
              disabled={isLoading}
            >
              Cargar Receta
            </Button>
          </Group>
        </form>
      </div>
    </Paper>
  );
}
